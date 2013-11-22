-- Paddle

require 'class'

-- constants

PADDLE_WIDTH = 128
PADDLE_HEIGHT = 64
PADDLE_IMG = "img/game_paddle.png"
PADDLE_INDEX_MIN = 0
PADDLE_INDEX_MAX = 5
PADDLE_SPEED = 60
PADDLE_MODE_NORMAL = 'mode_normal'
PADDLE_MODE_ASPIRATOR = 'mode_aspirator'
DELAY_PADDLE_ASPIRATOR_MODE = 10000
PADDLE_ASPIRATOR_MODE_IMG = "img/game_paddle_with_aspirator.png"
PADDLE_ASPIRATOR_PADDING = 50

-- variables

local pad
local lastTouchedX
local currentShowBounds

-- functions

local function onTouchScreen(event)
	lastTouchedX = event.x

	--[[
	-- Code for the arcade mode paddle mouvements
	local newX
	local newY

	if pad ~= nil then
		newX = event.x
		newY = event.y
		if newX - pad.width / 2 < 0 then
			newX = pad.width / 2
		end
		if newX + pad.width / 2 > display.contentWidth then
			newX = display.contentWidth - pad.width / 2
		end

		if newY - pad.height / 2 < 0 then
			newY = pad.height / 2
		end
		if newY + pad.height / 2 > display.contentHeight then
			newY = display.contentHeight - pad.height / 2
		end

		pad.x = newX
		pad.y = newY
	end
	--]]
end

-- core

Paddle = class(function(this)
	this.mode = PADDLE_MODE_NORMAL
end)

function Paddle:move()
	local dist
	local direction

	if lastTouchedX ~= nil and pad ~= nil then
		if pad.x > lastTouchedX then
			dist = pad.x - lastTouchedX
			direction = -1
		else
			dist = lastTouchedX - pad.x
			direction = 1
		end

		if dist < PADDLE_SPEED then
			pad.x = lastTouchedX
		else
			pad:translate(PADDLE_SPEED * direction, 0)
		end
	end
end

function Paddle:elem()
	return pad
end

function Paddle:onEnterScene()
	pad = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
	pad.x = display.contentCenterX
	pad.y = display.contentHeight - pad.height / 2

	Runtime:addEventListener("touch", onTouchScreen)
end

function Paddle:onExitScene()
	lastTouchedX = display.contentCenterX
	display.remove(pad)
	pad = nil
	Runtime:removeEventListener("touch", onTouchScreen)
end

function Paddle:contentBounds()
	if pad ~= nil then
		local bounds = pad.contentBounds
		bounds.xMin = bounds.xMin + 5
		bounds.xMax = bounds.xMax - 25
		bounds.yMin = bounds.yMin + 10
		bounds.yMax = bounds.yMax - 20

		return bounds
	end

	return nil
end

function Paddle:aspiratorContentBounds()
	if pad ~= nil then
		local bounds = self:contentBounds()
		bounds.xMin = bounds.xMin - PADDLE_ASPIRATOR_PADDING
		bounds.xMax = bounds.xMax + PADDLE_ASPIRATOR_PADDING
		bounds.yMin = bounds.yMin - PADDLE_ASPIRATOR_PADDING
		bounds.yMax = bounds.yMax + PADDLE_ASPIRATOR_PADDING

		--currentShowBounds = showBounds(bounds, currentShowBounds)

		return bounds
	end

	return nil
end

function Paddle:toAspiratorMode(activate)
	if pad ~= nil then
		if activate == true then
			local oldPad = pad
			pad = display.newImageRect(PADDLE_ASPIRATOR_MODE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
			pad.x = oldPad.x
			pad.y = oldPad.y
			
			display.remove(oldPad)
			oldPad = nil

			self.mode = PADDLE_MODE_ASPIRATOR

			timer.performWithDelay(DELAY_PADDLE_ASPIRATOR_MODE - 2000, function () blink(pad, BLINK_SPEED_NORMAL) end)
			timer.performWithDelay(DELAY_PADDLE_ASPIRATOR_MODE, function () self:toAspiratorMode(false) end)
		else
			local oldPad = pad
			pad = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
			pad.x = oldPad.x
			pad.y = oldPad.y
			
			self.mode = PADDLE_MODE_NORMAL

			display.remove(oldPad)
			oldPad = nil
		end
	end
end

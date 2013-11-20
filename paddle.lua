-- Paddle

require 'class'

-- constants

local PADDLE_WIDTH = 128
local PADDLE_HEIGHT = 64
local PADDLE_IMG = "img/game_paddle.png"
local PADDLE_INDEX_MIN = 0
local PADDLE_INDEX_MAX = 5
local PADDLE_SPEED = 60

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
end)

function Paddle:move()
	local dist
	local direction

	if lastTouchedX ~= nil then
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

function Paddle:onEnterScene()
	pad = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
	pad.x = display.contentCenterX
	pad.y = display.contentHeight - pad.height / 2

	Runtime:addEventListener("touch", onTouchScreen)
end

function Paddle:onExitScene()
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
		bounds.yMax = bounds.yMax - 7

		--currentShowBounds = showBounds(bounds, currentShowBounds)

		return bounds
	end

	return nil
end
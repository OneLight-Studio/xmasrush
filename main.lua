require "game"
require "paddle"

-- constants

local PRESENT_SIZE = 32
local PRESENT_IMG = "img/present.png"
local PRESENT_MIN_SPEED = 1
local PRESENT_MAX_SPEED = 8
local DELAY_BETWEEN_PRESENTS_MIN = 300
local DELAY_BETWEEN_PRESENTS_MODIFIER = 10
local LIVES_START = 10

-- variables

local delayBetweenPresents = 1000
local items = {}
local game
local paddle

-- functions

local function newPresent()
	local present = display.newImageRect(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE)
	present.speed = math.random(PRESENT_MIN_SPEED, PRESENT_MAX_SPEED)
	present.catchFunction = function ()
		game:increaseScore(1)
	end
	present.missFunction = function ()
		game:decreaseLives(1)
	end
	return present
end

local function dropItem(item)
	table.insert(items, item)
	-- drop the item randomly on the x-axis
	item.x = math.random(item.width / 2, display.contentWidth - item.width / 2)
	item.y = -item.height / 2
end

local function dropPresent()
	dropItem(newPresent())
	delayBetweenPresents = math.max(500, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)
	timer.performWithDelay(delayBetweenPresents, dropPresent)
end

-- events

local function onEveryFrame(event)
	-- move each item
	for i, item in pairs(items) do
		item:translate(0, item.speed)
		local itemBounds = item.contentBounds
		local paddleBounds = paddle:contentBounds()
		-- remove the item if it is in the box
		if itemBounds.xMin >= paddleBounds.xMin and itemBounds.xMax <= paddleBounds.xMax and itemBounds.yMax >= paddleBounds.yMin then
			table.remove(items, i)
			display.remove(item)
			item.catchFunction()
		-- remove the item if it is out of the screen
		elseif itemBounds.yMin > display.contentHeight then
			table.remove(items, i)
			display.remove(item)
			item.missFunction()
		end
	end
	-- keep the test visible
	Game:scoreLivesToFront()
end

-- init
math.randomseed(os.time())
display.setStatusBar(display.HiddenStatusBar)

-- listeners
Runtime:addEventListener("enterFrame", onEveryFrame)

-- start
paddle = Paddle()

game = Game(0,LIVES_START)
game:updateScore()
game:updateLives()

dropPresent()
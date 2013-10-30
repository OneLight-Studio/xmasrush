require "game"
require "paddle"
require "item"

-- constants

local DELAY_BETWEEN_PRESENTS_MIN = 300
local DELAY_BETWEEN_PRESENTS_MODIFIER = 10
local LIVES_START = 10

-- variables

local delayBetweenPresents = 1000
local items = {}
local game
local paddle

-- functions

local function dropPresent()
	local item = Item(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE, PRESENT_MIN_SPEED, PRESENT_MAX_SPEED, 1, 1)
	table.insert(items, item)

	delayBetweenPresents = math.max(500, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)

	timer.performWithDelay(delayBetweenPresents, dropPresent)
end

-- events

local function onEveryFrame(event)
	-- move each item
	for i, item in pairs(items) do
		item:startTranslate()

		local itemBounds = item:contentBounds()
		local paddleBounds = paddle:contentBounds()
		-- remove the item if it is in the box
		if itemBounds.xMin >= paddleBounds.xMin and itemBounds.xMax <= paddleBounds.xMax and itemBounds.yMax >= paddleBounds.yMin then
			table.remove(items, i)

			item:remove()
			game:increaseScore(item.scoreBonus)
		-- remove the item if it is out of the screen
		elseif itemBounds.yMin > display.contentHeight then
			table.remove(items, i)

			item:remove()
			game:decreaseLives(item.lifeMalus)
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
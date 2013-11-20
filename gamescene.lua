require "game"
require "paddle"
require "item"

-- constants

local DELAY_BETWEEN_PRESENTS_MIN = 300
local DELAY_BETWEEN_PRESENTS_MODIFIER = 10
local DELAY_BETWEEN_BOMBS_MIN = 1000
local DELAY_BETWEEN_BOMBS_MODIFIER = 10
local DELAY_BETWEEN_LIVES_MIN = 5000
local DELAY_BETWEEN_LIVES_MODIFIER = 1000
local DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE = 10000
local MAX_PRESENTS_ON_SCREEN = 7
local LIVES_START = 10

-- variables

local delayBetweenPresents = 1000
local delayBetweenBombs = 5000
local delayBetweenLives = 10000
local items = {}
local game
local paddle
local audioLoop
local audioLoopSource
local audioLoopPitch

-- functions

local function newPresent()
	return Item(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE, PRESENT_MIN_SPEED, PRESENT_MAX_SPEED, function() game:increaseScore(1)	end, function()	game:decreaseLives(1) end, PRESENT_SOUND)
end

local function newBomb()
	return Item(BOMB_IMG, BOMB_SIZE, BOMB_SIZE, BOMB_MIN_SPEED, BOMB_MAX_SPEED, function() game:decreaseLives(5) end, nil, BOMB_SOUND)
end

local function newLife()
	return Item(LIFE_IMG, LIFE_SIZE, LIFE_SIZE, LIFE_MIN_SPEED, LIFE_MAX_SPEED, function() game:increaseLives(1) end, nil, LIFE_SOUND)
end

local function dropPresent()
	if table.getn(items) < MAX_PRESENTS_ON_SCREEN then
		local present = newPresent()
		table.insert(items, present)
	end

	delayBetweenPresents = math.max(DELAY_BETWEEN_PRESENTS_MIN, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)

	timer.performWithDelay(delayBetweenPresents, dropPresent)
end

local function dropBomb()
	local bomb = newBomb()
	table.insert(items, bomb)

	delayBetweenBombs = math.max(DELAY_BETWEEN_BOMBS_MIN, delayBetweenBombs - DELAY_BETWEEN_BOMBS_MODIFIER)

	timer.performWithDelay(delayBetweenBombs, dropBomb)
end

local function dropLife()
	local life = newLife()
	table.insert(items, life)

	delayBetweenLives = math.max(DELAY_BETWEEN_LIVES_MIN, delayBetweenLives - DELAY_BETWEEN_LIVES_MODIFIER)

	timer.performWithDelay(delayBetweenLives, dropLife)
end

local function increaseAudioLoopPitch()
	audioLoopPitch = audioLoopPitch + 0.01
	al.Source(audioLoopSource, al.PITCH, audioLoopPitch)
	timer.performWithDelay(DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE, increaseAudioLoopPitch)
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
			--game:increaseScore(item.scoreBonus)
			item:onHit(game)
		-- remove the item if it is out of the screen
		elseif itemBounds.yMin > display.contentHeight then
			table.remove(items, i)

			item:remove()
			--game:decreaseLives(item.lifeMalus)
			item:onFall(game)
		end
	end
	-- keep the text visible
	Game:scoreLivesToFront()
end

-- init
math.randomseed(os.time())
display.setStatusBar(display.HiddenStatusBar)

-- listeners
Runtime:addEventListener("enterFrame", onEveryFrame)

-- sounds
audioLoop = audio.loadSound("sound/jingle_bells.mp3")

-- start
paddle = Paddle()

game = Game(0,LIVES_START)
game:updateScore()
game:updateLives()

audio.play(audioLoop, { channel=1, loops=-1 })
audioLoopSource = audio.getSourceFromChannel(1)
audioLoopPitch = 1
timer.performWithDelay(DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE, increaseAudioLoopPitch)

dropPresent()
timer.performWithDelay(delayBetweenBombs, dropBomb)
timer.performWithDelay(delayBetweenLives, dropLife)

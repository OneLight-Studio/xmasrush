-- Scene Game

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
local DELAY_BETWEEN_BONUS = 30000
local DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE = 10000
local INIT_MAX_ITEMS_ON_SCREEN = 4
local DELAY_BETWEEN_MAX_ITEMS_ON_SCREEN = 15000
local LIVES_START = 10

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local menuButton
local delayBetweenPresents
local delayBetweenBombs
local delayBetweenLives
local itemsCountOnScreen
local items = {}
local game
local paddle
local audioLoop
local audioLoopSource
local audioLoopPitch
local maxItemsOnScreenTimerId
local presentTimerId
local bombTimerId
local lifeTimerId
local bonusTimerId
local starWaterfallTimerId
local audioTimerId
local starDroppingIndex = 0
local starDroppingMax = 20
local isOnPause = false
local songChannel

-- local functions

function startHit()
	for i, item in pairs(items) do
		item:remove()
	end

	timer.pause(bombTimerId)
	timer.pause(lifeTimerId)
	timer.pause(presentTimerId)
	timer.pause(audioTimerId)

	al.Source(audioLoopSource, al.PITCH, 2)

	dropPresentLine()
end

function pauseGame()
	isOnPause = true

	audio.pause(songChannel)

	if starWaterfallTimerId ~= nil then
		timer.pause(starWaterfallTimerId)
	else
		timer.pause(bombTimerId)
		timer.pause(lifeTimerId)
		timer.pause(bonusTimerId)
		timer.pause(presentTimerId)
		timer.pause(audioTimerId)
		timer.pause(maxItemsOnScreenTimerId)
	end
end

function resumeGame()
	isOnPause = false

	audio.resume(songChannel)
	
	if starWaterfallTimerId ~= nil then
		timer.resume(starWaterfallTimerId)
	else
		timer.resume(bombTimerId)
		timer.resume(lifeTimerId)
		timer.resume(bonusTimerId)
		timer.resume(presentTimerId)
		timer.resume(audioTimerId)
		timer.resume(maxItemsOnScreenTimerId)
	end
end

function dropPresentLine()
	if starDroppingIndex < starDroppingMax then
		local prensentNumberPerRow = math.floor(display.contentWidth / PRESENT_SIZE)
		
		for i=0, prensentNumberPerRow, 1 do
			local present = Item(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE, 7, 7, function() game:increaseScore(1) end, nil, nil)
			table.insert(items, present)
			present:onEnterScene()
		end

		starDroppingIndex = starDroppingIndex + 1
		if starDroppingIndex < starDroppingMax then
			starWaterfallTimerId = timer.performWithDelay(200, dropPresentLine)
		else
			starWaterfallTimerId = timer.performWithDelay(2000, dropPresentLine)
		end
	else
		starDroppingIndex = 0
		timer.resume(bombTimerId)
		timer.resume(lifeTimerId)
		timer.resume(presentTimerId)

		al.Source(audioLoopSource, al.PITCH, audioLoopPitch)
		timer.resume(audioTimerId)

		clearItems()
	end
end

local function inscreaseMaxItems()
	itemsCountOnScreen = itemsCountOnScreen + 1
	maxItemsOnScreenTimerId = timer.performWithDelay(DELAY_BETWEEN_MAX_ITEMS_ON_SCREEN, inscreaseMaxItems)
end

local function dropPresent()
	if table.getn(items) < itemsCountOnScreen then
		local present = Item(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE, PRESENT_MIN_SPEED, PRESENT_MAX_SPEED, function() game:increaseScore(1) end, function() game:decreaseLives(1) end, PRESENT_SOUND)
		table.insert(items, present)
		present:onEnterScene()
	end

	delayBetweenPresents = math.max(DELAY_BETWEEN_PRESENTS_MIN, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)

	presentTimerId = timer.performWithDelay(delayBetweenPresents, dropPresent)
end

local function dropBomb()
	local bomb = Item(BOMB_IMG, BOMB_SIZE, BOMB_SIZE, BOMB_MIN_SPEED, BOMB_MAX_SPEED, function() game:decreaseLives(5) end, nil, BOMB_SOUND)
	table.insert(items, bomb)
	bomb:onEnterScene()

	delayBetweenBombs = math.max(DELAY_BETWEEN_BOMBS_MIN, delayBetweenBombs - DELAY_BETWEEN_BOMBS_MODIFIER)

	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
end

local function dropLife()
	local life = Item(LIFE_IMG, LIFE_SIZE, LIFE_SIZE, LIFE_MIN_SPEED, LIFE_MAX_SPEED, function() game:increaseLives(1) end, nil, LIFE_SOUND)
	table.insert(items, life)
	life:onEnterScene()

	delayBetweenLives = math.max(DELAY_BETWEEN_LIVES_MIN, delayBetweenLives - DELAY_BETWEEN_LIVES_MODIFIER)

	lifeTimerId = timer.performWithDelay(delayBetweenLives, dropLife)
end

local function dropBonus()
	local bonusType = 1 -- math.random(1,3)
	local bonus

	if bonusType == 1 then
		bonus = Item(STAR_IMG, STAR_SIZE, STAR_SIZE, STAR_MIN_SPEED, STAR_MAX_SPEED, function() startHit() end, nil, nil)
	elseif bonusType == 2 then
		bonus = Item(IMP_IMG, IMP_SIZE, IMP_SIZE, IMP_MIN_SPEED, IMP_MAX_SPEED, function() impHit() end, nil, nil)
	elseif bonusType == 3 then
		bonus = Item(ASPIRATOR_IMG, ASPIRATOR_SIZE, ASPIRATOR_SIZE, ASPIRATOR_MIN_SPEED, ASPIRATOR_MAX_SPEED, function() aspiratorHit() end, nil, nil)
	end

	table.insert(items, bonus)
	bonus:onEnterScene()

	bonusTimerId = timer.performWithDelay(DELAY_BETWEEN_BONUS, dropBonus)
end

local function increaseAudioLoopPitch()
	audioLoopPitch = audioLoopPitch + 0.01
	al.Source(audioLoopSource, al.PITCH, audioLoopPitch)
	audioTimerId = timer.performWithDelay(DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE, increaseAudioLoopPitch)
end

-- events

local function onEveryFrame(event)
	if isOnPause == false then
		-- move paddle
		paddle:move()

		-- move each item
		for i, item in pairs(items) do
			item:startTranslate()

			local itemBounds = item:contentBounds()
			local paddleBounds = paddle:contentBounds()

			if itemBounds ~= nil and paddleBounds ~= nil then
				-- remove the item if it is in the box
				if itemBounds.xMin >= paddleBounds.xMin and itemBounds.xMax <= paddleBounds.xMax and itemBounds.yMax >= paddleBounds.yMin then
					table.remove(items, i)
					item:remove()
					item:onHit(game)
				-- remove the item if it is out of the screen
				elseif itemBounds.yMin > display.contentHeight then
					table.remove(items, i)
					item:remove()
					item:onFall(game)
				end
			end
		end

		-- check lives
		if game.lives <= 0 then
			Runtime:removeEventListener("enterFrame", onEveryFrame)
			storyboard.showOverlay( "scene_game_over", {isModal = true} )
		else
			-- keep the text visible
			game:scoreLivesToFront()
			menuButton:toFront()
		end
	end
end

function clearItems()
	for i, item in pairs(items) do
		item:onExitScene()
		items[i] = nil
	end
end

-- scene functions

function scene:createScene( event )
    paddle = Paddle()
	game = Game(0,LIVES_START)
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	-- init
	math.randomseed(os.time())

	-- listeners
	Runtime:addEventListener("enterFrame", onEveryFrame)

	-- sounds
	audioLoop = audio.loadSound("sound/jingle_bells.mp3")
	songChannel = audio.play(audioLoop, { channel=1, loops=-1 })
	audioLoopSource = audio.getSourceFromChannel(1)
	audioLoopPitch = 1
	audioTimerId = timer.performWithDelay(DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE, increaseAudioLoopPitch)

	-- start
	bg = display.newImage( "img/bg.jpg" )
	menuButton = display.newImage("img/game_pause.png")
	menuButton.x = menuButton.width / 2 + 5
	menuButton.y = menuButton.height / 2 + 5
	menuButton:addEventListener("tap", function ( event )
	    storyboard.showOverlay( "scene_game_pause", {isModal = true} )
	end)

	delayBetweenPresents = 600
	delayBetweenBombs = 4000
	delayBetweenLives = 10000
	itemsCountOnScreen = INIT_MAX_ITEMS_ON_SCREEN

	paddle:onEnterScene()
	game:onEnterScene()

	dropPresent()
	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
	lifeTimerId = timer.performWithDelay(delayBetweenLives, dropLife)
	bonusTimerId = timer.performWithDelay(DELAY_BETWEEN_BONUS, dropBonus)
	maxItemsOnScreenTimerId = timer.performWithDelay(DELAY_BETWEEN_MAX_ITEMS_ON_SCREEN, inscreaseMaxItems)
end

function scene:exitScene( event )
	Runtime:removeEventListener("enterFrame", onEveryFrame)

	display.remove(bg)
	bg = nil
	display.remove(menuButton)
	menuButton = nil

	paddle:onExitScene()
	game:onExitScene()
	clearItems()

	timer.cancel(audioTimerId)
	timer.cancel(presentTimerId)
	timer.cancel(bombTimerId)
	timer.cancel(lifeTimerId)
	timer.cancel(bonusTimerId)
	timer.cancel(maxItemsOnScreenTimerId)

	audio.stop(songChannel)
end

function scene:destroyScene( event )
	-- Nothing
end

function scene:overlayBegan( event )
    pauseGame()
end

function scene:overlayEnded( event )
    resumeGame()
end

-- core

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "overlayBegan" )
scene:addEventListener( "overlayEnded" )

return scene
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
local DELAY_BETWEEN_BONUS = 10000
local DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE = 5000
local IMP_DELAY = 10000
local INIT_MAX_ITEMS_ON_SCREEN = 4
local DELAY_BETWEEN_MAX_ITEMS_ON_SCREEN = 15000
local LIVES_START = 10

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
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
local bonusTimerId
local impBonusTimerId
local starWaterfallTimerId
local audioTimerId
local starDroppingIndex = 0
local starDroppingMax = 20
local isOnPause = false
local songChannel
local imp

-- local functions

local function createMenuBtn()
	menuButton = widget.newButton({
		defaultFile = "img/game_pause.png",
		overFile = "img/game_pause_pressed.png",
		onRelease = function(event)
			showPause()
		end
	})
	menuButton.x = menuButton.width / 2 + 5
	menuButton.y = menuButton.height / 2 + 5
end

function showPause()
	storyboard.showOverlay( "scene_game_pause", {isModal = true} )
end

function pauseGame()
	isOnPause = true
	menuButton:removeSelf()
	menuButton = nil

	audio.pause(songChannel)

	if starWaterfallTimerId ~= nil then
		timer.pause(starWaterfallTimerId)
	end
	if impBonusTimerId ~= nil then
		timer.pause(impBonusTimerId)
	end

	timer.pause(bombTimerId)
	timer.pause(bonusTimerId)
	timer.pause(presentTimerId)
	timer.pause(audioTimerId)
	timer.pause(maxItemsOnScreenTimerId)
end

function resumeGame()
	if gameSettings.soundEnable then
		audio.resume(songChannel)
	end

	if starWaterfallTimerId ~= nil then
		timer.resume(starWaterfallTimerId)
	end
	if impBonusTimerId ~= nil then
		timer.resume(impBonusTimerId)
	end

	timer.resume(bombTimerId)
	timer.resume(bonusTimerId)
	timer.resume(presentTimerId)
	timer.resume(audioTimerId)
	timer.resume(maxItemsOnScreenTimerId)

	createMenuBtn()
	isOnPause = false

	print("resume")
end

function startHit()
	for i, item in pairs(items) do
		item:remove()
	end

	timer.pause(bombTimerId)
	timer.pause(presentTimerId)
	timer.pause(audioTimerId)

	al.Source(audioLoopSource, al.PITCH, 2)

	dropPresentLine()
end

function impHit()
	imp = Item(TYPE_IMP, nil, nil)
	imp:onEnterScene(IMP_WIDTH / 2, display.contentHeight / 2)

	impBonusTimerId = timer.performWithDelay(IMP_DELAY, endImp)
end

function endImp()
	if imp ~= nil then
		imp:onExitScene()
		imp = nil
		impBonusTimerId = nil
	end
end

function dropPresentLine()
	if starDroppingIndex < starDroppingMax then
		local prensentNumberPerRow = math.floor(display.contentWidth / PRESENT_WIDTH)
		
		for i=0, prensentNumberPerRow, 1 do
			local present = Item(TYPE_STAR_PRESENT, function() game:increaseScore(1) end, nil)
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
		starWaterfallTimerId = nil
		starDroppingIndex = 0
		timer.resume(bombTimerId)
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
		local present = Item(TYPE_PRESENT, function() game:increaseScore(1) end, function() game:decreaseLives(1) end)
		table.insert(items, present)
		present:onEnterScene()
	end

	delayBetweenPresents = math.max(DELAY_BETWEEN_PRESENTS_MIN, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)

	presentTimerId = timer.performWithDelay(delayBetweenPresents, dropPresent)
end

local function dropBomb()
	local bomb = Item(TYPE_BOMB, function() game:decreaseLives(5) end, nil)
	table.insert(items, bomb)
	bomb:onEnterScene()

	delayBetweenBombs = math.max(DELAY_BETWEEN_BOMBS_MIN, delayBetweenBombs - DELAY_BETWEEN_BOMBS_MODIFIER)

	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
end

local function dropBonus()
	local bonusType = math.random(1,4)
	local bonus

	if bonusType == 1 then
		bonus = Item(TYPE_STAR_BONUS, function() startHit() end, nil, nil)
	elseif bonusType == 2 then
		bonus = Item(TYPE_IMP_BONUS, function() impHit() end, nil, nil)
	elseif bonusType == 3 then
		bonus = Item(TYPE_LIFE_BONUS, function() game:increaseLives(1) end, nil, nil)
	elseif bonusType == 4 then
		bonus = Item(TYPE_ASPIRATOR_BONUS, function() paddle:toAspiratorMode(true) end, nil, nil)
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

		local impBounds
		local itemBounds
		local paddleAspiratorBounds
		local paddleBounds = paddle:contentBounds()

		if paddle.mode == PADDLE_MODE_ASPIRATOR then
			paddleAspiratorBounds = paddle:aspiratorContentBounds()
		end

		if imp ~= nil then
			impBounds = imp:contentBounds()
		end

		-- move each item
		for i, item in pairs(items) do
			item:startTranslate()

			itemBounds = item:contentBounds()

			if itemBounds ~= nil and paddleBounds ~= nil then
				-- remove the item if it is in the paddle
				if paddleAspiratorBounds ~= nil and item.type == TYPE_PRESENT and item.aspirated == nil then
					if isBoundsInBounds(itemBounds, paddleAspiratorBounds) then
						local toX = paddleBounds.xMin + ((paddleBounds.xMax - paddleBounds.xMin) / 2)
						local toY = paddleBounds.yMin + 10

						item:aspiratedTo(toX, toY)
					end
				else
					if isBoundsInBounds(itemBounds, paddleBounds) or item:aspiratedDone() then
						table.remove(items, i)
						item:remove()
						item:onHit(game)
					end
				end

				-- remove only present items if it is in the imp
				if imp ~= nil and impBounds ~= nil then
					if isBoundsInBounds(itemBounds, impBounds) and item.type == TYPE_PRESENT then
						table.remove(items, i)
						item:remove()
						item:onHit(game)
					end
				end
				
				-- remove the item if it is out of the screen
				if itemBounds.yMin > display.contentHeight then
					table.remove(items, i)
					item:remove()
					item:onFall(game)
				end
			end
		end

		-- check lives
		if game.lives <= 0 then
			Runtime:removeEventListener("enterFrame", onEveryFrame)
			audio.play(audio.loadSound("sound/game_over.wav"))
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
	if gameSettings.soundEnable == false then
		audio.pause(songChannel)
	end
	audioLoopSource = audio.getSourceFromChannel(1)
	audioLoopPitch = 1
	al.Source(audioLoopSource, al.PITCH, audioLoopPitch)
	audioTimerId = timer.performWithDelay(DELAY_BETWEEN_AUDIO_LOOP_PITCH_INCREASE, increaseAudioLoopPitch)

	-- start
	bg = display.newImage( "img/bg.jpg" )
	createMenuBtn()

	delayBetweenPresents = 600
	delayBetweenBombs = 4000
	delayBetweenLives = 10000
	itemsCountOnScreen = INIT_MAX_ITEMS_ON_SCREEN

	paddle:onEnterScene()
	game:onEnterScene()

	dropPresent()
	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
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
	timer.cancel(bonusTimerId)
	timer.cancel(maxItemsOnScreenTimerId)
	if impBonusTimerId ~= nil then
		timer.cancel(impBonusTimerId)
	end
	if starWaterfallTimerId ~= nil then
		timer.cancel(starWaterfallTimerId)
	end

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

-- Scene Game

require "game"
require "paddle"
require "item"

-- constants

local PRESENT_SPEED = { { 2, 3 }, { 2, 4 }, { 2, 5 }, { 3, 5 }, { 4, 5 }, { 4, 6 }, { 4, 7 }, { 5, 7 }, { 6, 7 }, { 7, 7 } }
local DELAY_BETWEEN_PRESENTS = { 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100 }
local DELAY_BETWEEN_BOMBS = { 10000, 9000, 8000, 7000, 6000, 5000, 4000, 3000, 2000, 1000 }
local DELAY_BETWEEN_BONUS = 15000
local AUDIO_PITCH = { 1.0, 1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.35, 1.4, 1.45 }
local IMP_DELAY = 10000
local MAX_ITEMS_ON_SCREEN = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
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
local itemsCountOnScreen
local items = {}
local game
local paddle
local audioLoop
local audioLoopSource
local audioLoopPitch
local presentTimerId
local bombTimerId
local bonusTimerId
local impBonusTimerId
local impBlinkTimerId
local impToLeft
local starWaterfallTimerId
local starDroppingIndex = 0
local starDroppingMax = 20
local isOnPause = false
local songChannel
local imp
local level

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
		timer.pause(impBlinkTimerId)
	end

	timer.pause(bombTimerId)
	timer.pause(bonusTimerId)
	timer.pause(presentTimerId)

	paddle:pausePaddle()
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
		timer.resume(impBlinkTimerId)
	end

	timer.resume(bombTimerId)
	timer.resume(bonusTimerId)
	timer.resume(presentTimerId)

	paddle:resumePaddle()

	createMenuBtn()
	isOnPause = false
end

function startHit()
	for i, item in pairs(items) do
		item:remove()
	end

	timer.pause(bombTimerId)
	timer.pause(presentTimerId)

	al.Source(audioLoopSource, al.PITCH, 2)

	dropPresentLine()
end

function impHit()
	imp = Item(TYPE_IMP, nil, nil)

	if impToLeft == nil or impToLeft == false then
		impToLeft = true
		imp:impToLeft(true)
		imp:onEnterScene(IMP_WIDTH / 2, display.contentHeight / 2)
	else
		imp:impToLeft(false)
		imp:onEnterScene(display.contentWidth - (IMP_WIDTH / 2), display.contentHeight / 2)
		impToLeft = false
	end

	impBlinkTimerId = timer.performWithDelay(IMP_DELAY - 2000, function ()
		if imp ~= nil and imp:elem() ~= nil then 
			blink(imp:elem(), BLINK_SPEED_NORMAL)
		end
	end)

	impBonusTimerId = timer.performWithDelay(IMP_DELAY, endImp)
end

function endImp()
	if imp ~= nil then
		imp:onExitScene()
		imp = nil
		impBonusTimerId = nil
		impBlinkTimerId = nil
	end
end

function dropPresentLine()
	if starDroppingIndex < starDroppingMax then
		local prensentNumberPerRow = math.floor(display.contentWidth / PRESENT_WIDTH) / 5
		
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

		clearItems()
	end
end

local function dropPresent()
	if table.getn(items) < itemsCountOnScreen then
		local present = Item(TYPE_PRESENT, function() game:increaseScore(1) end, function() game:decreaseLives(1) end, PRESENT_SPEED[game.level][1], PRESENT_SPEED[game.level][2])
		table.insert(items, present)
		present:onEnterScene()
	end

	audioLoopPitch = AUDIO_PITCH[game.level]
	al.Source(audioLoopSource, al.PITCH, audioLoopPitch)
	itemsCountOnScreen = MAX_ITEMS_ON_SCREEN[game.level]
	delayBetweenPresents = DELAY_BETWEEN_PRESENTS[game.level]
	presentTimerId = timer.performWithDelay(delayBetweenPresents, dropPresent)
end

local function dropBomb()
	local bomb = Item(TYPE_BOMB, function()
		game:decreaseLives(5)
		blink(paddle:elem(), BLINK_SPEED_FAST)
	end, nil)
	table.insert(items, bomb)
	bomb:onEnterScene()

	delayBetweenBombs = DELAY_BETWEEN_BOMBS[game.level]
	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
end

local function dropBonus()
	local bonusType = math.random(1,4)
	local bonus

	if bonusType == 1 and game.level >= 5 then
		bonus = Item(TYPE_STAR_BONUS, function() startHit() end, nil, nil)
	elseif bonusType == 2 and game.level >= 3 then
		bonus = Item(TYPE_IMP_BONUS, function() impHit() end, nil, nil)
	elseif bonusType == 3 and game.level >= 2 then
		bonus = Item(TYPE_LIFE_BONUS, function() game:increaseLives(3) end, nil, nil)
	elseif bonusType == 4 and game.level >= 4 then
		bonus = Item(TYPE_ASPIRATOR_BONUS, function() paddle:toAspiratorMode(true) end, nil, nil)
	end

	if bonus then
		table.insert(items, bonus)
		bonus:onEnterScene()

		bonusTimerId = timer.performWithDelay(DELAY_BETWEEN_BONUS, dropBonus)
	elseif game.level > 1 then
		-- retry
		dropBonus()
	end
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
			game:gameOver()
			storyboard.showOverlay( "scene_game_over", {isModal = true, params = { game = game }} )
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
	-- Nothing
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
    paddle = Paddle()
	game = Game(event.params and event.params.level or 1, LIVES_START)

	-- init
	math.randomseed(os.time())

	audio.stop()
	audio.setVolume(1.0)

	-- listeners
	Runtime:addEventListener("enterFrame", onEveryFrame)

	-- sounds
	audioLoop = audio.loadSound("sound/jingle_bells.mp3")

	songChannel = audio.play(audioLoop, { channel=1, loops=-1 })
	if gameSettings.soundEnable == false then
		audio.pause(songChannel)
	end
	audioLoopSource = audio.getSourceFromChannel(1)
	audioLoopPitch = AUDIO_PITCH[game.level]
	al.Source(audioLoopSource, al.PITCH, audioLoopPitch)

	-- start
	bg = display.newImage( "img/bg.jpg" )
	createMenuBtn()

	delayBetweenPresents = DELAY_BETWEEN_PRESENTS[game.level]
	delayBetweenBombs = DELAY_BETWEEN_BOMBS[game.level]
	itemsCountOnScreen = MAX_ITEMS_ON_SCREEN[game.level]

	paddle:onEnterScene()
	game:onEnterScene()

	dropPresent()
	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
	bonusTimerId = timer.performWithDelay(DELAY_BETWEEN_BONUS, dropBonus)
end

function scene:exitScene( event )
	Runtime:removeEventListener("enterFrame", onEveryFrame)

	display.remove(bg)
	bg = nil
	display.remove(menuButton)
	menuButton = nil

	paddle:onExitScene()
	game:onExitScene()
	endImp()
	clearItems()

	timer.cancel(presentTimerId)
	timer.cancel(bombTimerId)
	timer.cancel(bonusTimerId)
	if impBonusTimerId ~= nil then
		timer.cancel(impBonusTimerId)
		timer.cancel(impBlinkTimerId)
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
	if game.restart then
		self:exitScene()
		isOnPause = false
		self:enterScene({ params = { level = game.level } })
	else
		resumeGame()
	end
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

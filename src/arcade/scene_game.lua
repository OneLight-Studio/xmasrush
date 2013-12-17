-- Scene Game

require "src.arcade.game"
require "src.arcade.paddle"
require "src.common.item"

-- constants

local COUNTDOWN = 1500
local PRESENT_SPEED = { 8, 10 }
local DELAY_BETWEEN_PRESENTS = 250
local DELAY_BETWEEN_BOMBS = 2000
local DELAY_BETWEEN_BONUS = 5000
local AUDIO_PITCH = 1.5
local IMP_DELAY = 10000
local MAX_ITEMS_ON_SCREEN = 30
local X2_DELAY = 10000
local SNOWFLAKE_DELAY = 10000
local GAME_DURATION = 60
local BOMB_PAUSE = 3000

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local menuButton
local delayBetweenPresents
local delayBetweenBombs
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
local x2BonusTimerId
local snowflakeBonusTimerId
local impBlinkTimerId
local impToLeft
local starWaterfallTimerId
local starDroppingIndex = 0
local starDroppingMax = 20
local isOnPause = false
local isOnX2Bonus = false
local isOnSnowflakeBonus = false
local songChannel
local imp
local lastBonusType = -1
local bonusTutoTimerId
local gameTimer
local seconds
local bombPauseTimer

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

local function countdown(x)
	local countdownTxt = display.newText(x > 0 and x or language:getString("countdown.go"), 0, 0, FONT, 80)
	countdownTxt.x = display.contentCenterX
	countdownTxt.y = display.contentCenterY
	transition.to(countdownTxt, {
		alpha = 1, time = COUNTDOWN / 6, onComplete = function()
			transition.to(countdownTxt, {
				alpha = 0, time = COUNTDOWN / 6, onComplete = function()
					display.remove(countdownTxt)
					countdownTxt = nil
					if x > 0 then
						countdown(x - 1)
					end
				end
			})
		end
	})
end

function showPause()
	moveToOverlay( "scene_game_pause", {isModal = true, params = { game = game }} )
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
	if x2BonusTimerId ~= nil then
		timer.pause(x2BonusTimerId)
	end
	if snowflakeBonusTimerId ~= nil then
		timer.pause(snowflakeBonusTimerId)
	end
	if bonusTutoTimerId ~= nil then
		timer.pause(bonusTutoTimerId)
	end
	if bombPauseTimer then
		timer.pause(bombPauseTimer)
	end

	timer.pause(gameTimer)
	timer.pause(bombTimerId)
	timer.pause(bonusTimerId)
	timer.pause(presentTimerId)

	paddle:pausePaddle()
end

function resumeGame()
	countdown(3)
	timer.performWithDelay(COUNTDOWN, function()
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
		if x2BonusTimerId ~= nil then
			timer.resume(x2BonusTimerId)
		end
		if snowflakeBonusTimerId ~= nil then
			timer.resume(snowflakeBonusTimerId)
		end
		if bonusTutoTimerId ~= nil then
			timer.resume(bonusTutoTimerId)
		end
		if bombPauseTimer ~= nil then
			timer.resume(bombPauseTimer)
		end
		timer.resume(gameTimer)
		timer.resume(bombTimerId)
		timer.resume(bonusTimerId)
		timer.resume(presentTimerId)

		paddle:resumePaddle()

		createMenuBtn()
		isOnPause = false
	end)
end

function startHit()
	for i, item in pairs(items) do
		if item then
			items[i] = nil
			item:remove()
			item = nil
		end
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

function x2Hit()
	isOnX2Bonus = true
	x2BonusTimerId = timer.performWithDelay(X2_DELAY, endX2)
	for i,item in pairs(items) do
		if item and item.type == TYPE_PRESENT then
			local newItem = Item(TYPE_X2_PRESENT, function()
				game:increaseScore(2)
			end, item.fall, item.speed, item.speed)
			newItem:onEnterScene(item.element.x, item.element.y)
			items[i] = newItem
			item:remove()
			item = nil
		end
	end
end

function endX2()
	isOnX2Bonus = false
	x2BonusTimerId = nil
end

function snowflakeHit()
	isOnSnowflakeBonus = true
	snowflakeBonusTimerId = timer.performWithDelay(SNOWFLAKE_DELAY, endSnowflake)
	for i,item in pairs(items) do
		if item and item.type == TYPE_PRESENT then
			local newItem = Item(TYPE_SNOWFLAKE_PRESENT, item.hit, item.fall, PRESENT_SPEED[1] / 3, PRESENT_SPEED[2] / 3)
			newItem:onEnterScene(item.element.x, item.element.y)
			items[i] = newItem
			item:remove()
			item = nil
		end
	end
end

function endSnowflake()
	isOnSnowflakeBonus = false
	snowflakeBonusTimerId = nil
end

function bombHit()
	blink(paddle:elem(), BLINK_SPEED_BOMB)
	game:clearCombo()
	for i, item in pairs(items) do
		if item and item.type ~= TYPE_BOMB then
			transition.to(item:elem(), {
				xScale=2, yScale=2, alpha=0, time=300, onComplete=function(event)
					items[i] = nil
					item:remove()
					item = nil
				end
			})
		end
	end

	timer.pause(bonusTimerId)
	timer.pause(presentTimerId)
	bombPauseTimer = timer.performWithDelay(BOMB_PAUSE, endBombPause)
end

function endBombPause()
	timer.resume(bonusTimerId)
	timer.resume(presentTimerId)
end

function dropPresentLine()
	if starDroppingIndex < starDroppingMax then
		local prensentNumberPerRow = math.floor(display.contentWidth / PRESENT_WIDTH) / 5
		
		for i=0, prensentNumberPerRow, 1 do
			local present = Item(TYPE_STAR_PRESENT, function()
				game:increaseScore(1)
			end, nil)
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
	if #items < itemsCountOnScreen then
		local present
		if isOnX2Bonus then
			present = Item(TYPE_X2_PRESENT, 
				function() 
					game:increaseScore(2) 
				end, 
				nil,
				PRESENT_SPEED[1], 
				PRESENT_SPEED[2]
			)
		elseif isOnSnowflakeBonus then
			present = Item(TYPE_SNOWFLAKE_PRESENT,
				function() 
					game:increaseScore(1) 
				end,
				nil,
				PRESENT_SPEED[1] / 3,
				PRESENT_SPEED[2] / 3
			)
		else
			present = Item(TYPE_PRESENT,
				function() 
					game:increaseScore(1) 
				end, 
				nil,
				PRESENT_SPEED[1],
				PRESENT_SPEED[2]
			)
		end

		table.insert(items, present)
		present:onEnterScene()
		if not gameSettings.tuto[TYPE_PRESENT] then
			bonusTutoTimerId = timer.performWithDelay(500, function()
				gameSettings.tuto[TYPE_PRESENT] = true
				loadsave.saveTable(gameSettings, GAME_SETTINGS)
				moveToOverlay("scene_bonus_tuto", { isModal = true, params = { bonusType = TYPE_PRESENT, bonusItem = present } } )
			end)
		end
	end

	presentTimerId = timer.performWithDelay(delayBetweenPresents, dropPresent)
end

local function dropBomb()
	local bomb = Item(TYPE_BOMB, bombHit, nil)
	table.insert(items, bomb)
	bomb:onEnterScene()
	if not gameSettings.tuto[TYPE_BOMB] then
		bonusTutoTimerId = timer.performWithDelay(500, function()
			gameSettings.tuto[TYPE_BOMB] = true
			loadsave.saveTable(gameSettings, GAME_SETTINGS)
			moveToOverlay("scene_bonus_tuto", { isModal = true, params = { bonusType = TYPE_BOMB, bonusItem = bomb } } )
		end)
	end

	bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
end

local function dropBonus()
	local bonusType = math.random(1, 6)
	local bonus
	
	if bonusType == 1 then
		bonus = Item(TYPE_X2_BONUS, function() x2Hit() end, nil, nil)
	elseif bonusType == 2 then
		bonus = Item(TYPE_IMP_BONUS, function() impHit() end, nil, nil)
	elseif bonusType == 3 then
		paddle:toAspiratorMode(false)
		paddle:toBigMode(false)
		bonus = Item(TYPE_ASPIRATOR_BONUS, function() paddle:toAspiratorMode(true) end, nil, nil)
	elseif bonusType == 4 then
		bonus = Item(TYPE_STAR_BONUS, function() startHit() end, nil, nil)
	elseif bonusType == 5 then
		bonus = Item(TYPE_SNOWFLAKE_BONUS, function() snowflakeHit() end, nil, nil)
	elseif bonusType == 6 then
		paddle:toAspiratorMode(false)
		paddle:toBigMode(false)
		bonus = Item(TYPE_BIG_BONUS, function() paddle:toBigMode(true) end, nil, nil)
	end

	if bonusType == lastBonusType then
		-- force a different bonus
		dropBonus()
	else



		lastBonusType = bonusType
		table.insert(items, bonus)
		bonus:onEnterScene()
		bonusTimerId = timer.performWithDelay(DELAY_BETWEEN_BONUS, dropBonus)

		if not gameSettings.tuto[bonus.type] then
			bonusTutoTimerId = timer.performWithDelay(300, function()
				gameSettings.tuto[bonus.type] = true
				loadsave.saveTable(gameSettings, GAME_SETTINGS)
				moveToOverlay("scene_bonus_tuto", { isModal = true, params = { bonusType = bonus.type, bonusItem = bonus } } )
			end)
		end
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
			if item then
				item:startTranslate()

				itemBounds = item:contentBounds()

				if itemBounds ~= nil and paddleBounds ~= nil then
					-- remove the item if it is in the paddle
					if paddleAspiratorBounds ~= nil and item.type ~= TYPE_BOMB and item.aspirated == nil then
						if isBoundsInBounds(itemBounds, paddleAspiratorBounds) then
							local toX = paddleBounds.xMin + ((paddleBounds.xMax - paddleBounds.xMin) / 2)
							local toY = paddleBounds.yMin + 10

							item:aspiratedTo(toX, toY)
						end
					else
						if isBoundsInBounds(itemBounds, paddleBounds) or item:aspiratedDone() then
							items[i] = nil
							item:remove()
							if paddle.mode == PADDLE_MODE_BIG and item.type == TYPE_BOMB then
								--item:onHit(game, true)
							else
								item:onHit(game)
							end
						end
					end

					-- remove only present items if it is in the imp
					if imp ~= nil and impBounds ~= nil then
						if isBoundsInBounds(itemBounds, impBounds) then
							items[i] = nil
							item:remove()
							if item.type ~= TYPE_BOMB then
								item:onHit(game)
							end
						end
					end
					
					-- remove the item if it is out of the screen
					if itemBounds.yMin > display.contentHeight then
						items[i] = nil
						item:remove()
						item:onFall(game)
					end
				end

				-- put bombs to front
				if item.type == TYPE_BOMB then
					item:toFront()
				end
			end
		end

		game:textToFront()
		menuButton:toFront()
		paddle:toFront()
	end
end

function clearItems()
	for i, item in pairs(items) do
		if item then
			item:onExitScene()
			items[i] = nil
		end
	end
end

function gameCountdown()
	seconds = seconds - 1
	game:updateChrono(seconds)
	if seconds > 0 then
		gameTimer = timer.performWithDelay(1000, gameCountdown)
	else
		game:gameOver()
		moveToOverlay("arcade.scene_game_over", {isModal = true, params = { game = game }})
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
    paddle = PaddleArcade()
	game = GameArcade()

	-- init
	math.randomseed(os.time())

	audio.stop()
	audio.setVolume(1.0)

	bg = display.newImage( "img/bg.png" )
	bg.width = display.contentWidth
	bg.height = display.contentHeight
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY


	delayBetweenPresents = DELAY_BETWEEN_PRESENTS
	delayBetweenBombs = DELAY_BETWEEN_BOMBS
	itemsCountOnScreen = MAX_ITEMS_ON_SCREEN
	seconds = GAME_DURATION
	game:updateChrono(seconds)

	lastBonusType = -1

	paddle:onEnterScene()
	game:onEnterScene()

	countdown(3)

	timer.performWithDelay(COUNTDOWN, function()
		-- listeners
		Runtime:addEventListener("enterFrame", onEveryFrame)
		-- sounds
		audioLoop = audio.loadSound("sound/jingle_bells.mp3")
		songChannel = audio.play(audioLoop, { channel=1, loops=-1 })
		if gameSettings.soundEnable == false then
			audio.pause(songChannel)
		end
		audioLoopSource = audio.getSourceFromChannel(1)
		audioLoopPitch = AUDIO_PITCH
		al.Source(audioLoopSource, al.PITCH, audioLoopPitch)

		createMenuBtn()

		dropPresent()
		gameTimer = timer.performWithDelay(1000, gameCountdown)
		bombTimerId = timer.performWithDelay(delayBetweenBombs, dropBomb)
		bonusTimerId = timer.performWithDelay(DELAY_BETWEEN_BONUS, dropBonus)
	end)
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
	if x2BonusTimerId ~= nil then
		timer.cancel(x2BonusTimerId)
		isOnX2Bonus = false
	end
	if snowflakeBonusTimerId ~= nil then
		timer.cancel(snowflakeBonusTimerId)
		isOnSnowflakeBonus = false
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
		self:enterScene()
	elseif game.quit then
		self:exitScene()
		isOnPause = false
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

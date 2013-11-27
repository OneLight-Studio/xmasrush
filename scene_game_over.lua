-- Scene Game Over

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local gameOverText
local scoreText
local scoreImg
local highscoreText
local retryBtn
local quitBtn
local nbBtn = 0

local BTN_Y_MIN = 200

local function addButton(title, onTap)
	local btn = widget.newButton({
		defaultFile = BTN_IMG,
		overFile = BTN_IMG_PRESSED,
		label = title,
		labelColor = { default = BTN_LABEL_COLOR },
		font = FONT,
		fontSize = BTN_FONT_SIZE,
		onRelease = onTap
	})
	btn.x = display.contentCenterX
	btn.y = BTN_Y_MIN + nbBtn * (BTN_SIZE + BTN_GAP)
	nbBtn = nbBtn + 1
	return btn
end

-- scene functions

function scene:createScene( event )
    -- Nothing
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	if gameSettings.soundEffectEnable then
		audio.play(audio.loadSound("sound/game_over.mp3"))
	end

	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 180)

	gameOverText = display.newText(language:getString("game.over"), 0, 0, FONT, 60)
	gameOverText.x = display.contentCenterX
	gameOverText.y = display.contentCenterY - 120

	scoreImg = display.newImage("img/game_present_4.png")
	scoreImg.x = display.contentCenterX - 40
	scoreImg.y = display.contentCenterY - 50

	local game = event.params.game
	scoreText = display.newText(game.score, 0, 0, FONT, 40)
	scoreText.x = display.contentCenterX + 40
	scoreText.y = display.contentCenterY - 50

	--[[
	if game.newHighscore then
		timer.performWithDelay(350, function()
			highscoreText = display.newText(language:getString("highscore"), 0, 0, 200, 150, FONT, 30)
			highscoreText.x = display.contentCenterX + 170
			highscoreText.y = display.contentCenterY + 20
			highscoreText.align = "center"
			highscoreText:rotate(35)
			transition.from(highscoreText, { xScale = 5, yScale = 5, time = 100, onComplete = function()
				if gameSettings.soundEffectEnable then
					audio.play(audio.loadSound("sound/highscore.mp3"))
				end
			end})
		end)
	end
	--]]

	retryBtn = addButton(language:getString("menu.retry"), function()
		game.restart = true
		storyboard.hideOverlay()
	end)
	quitBtn = addButton(language:getString("menu.quit"), function() moveToScene("scene_home") end)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(gameOverText)
	display.remove(scoreImg)
	display.remove(scoreText)
	display.remove(highscoreText)
	display.remove(retryBtn)
	display.remove(quitBtn)
	bg = nil
	gameOverText = nil
	scoreImg = nil
	scoreText = nil
	highscoreText = nil
	retryBtn = nil
	quitBtn = nil
end

function scene:destroyScene( event )
	-- Nothing
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene

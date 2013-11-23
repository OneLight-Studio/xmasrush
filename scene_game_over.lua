-- Scene Game Over

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local gameOverText
local continueText
local scoreText
local scoreImg
local highscoreText

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
	gameOverText.y = display.contentCenterY - 100

	continueText = display.newText(language:getString("game.over.continue"), 0, 0, FONT, 30)
	continueText.x = display.contentCenterX
	continueText.y = display.contentCenterY + 100
	blink(continueText, 0)

	scoreImg = display.newImage("img/game_present_4.png")
	scoreImg.x = display.contentCenterX - 40
	scoreImg.y = display.contentCenterY

	local game = event.params.game
	scoreText = display.newText(game.score, 0, 0, FONT, 40)
	scoreText.x = display.contentCenterX + 40
	scoreText.y = display.contentCenterY

	if game.newHighscore then
		timer.performWithDelay(350, function()
			highscoreText = display.newText(language:getString("highscore"), 0, 0, 200, 150, FONT, 30)
			highscoreText.x = display.contentCenterX + 170
			highscoreText.y = display.contentCenterY + 50
			highscoreText.align = "center"
			highscoreText:rotate(35)
			transition.from(highscoreText, { xScale = 5, yScale = 5, time = 100, onComplete = function()
				if gameSettings.soundEffectEnable then
					audio.play(audio.loadSound("sound/highscore.mp3"))
				end
			end})
		end)
	end

	bg:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(gameOverText)
	display.remove(continueText)
	display.remove(scoreImg)
	display.remove(scoreText)
	display.remove(highscoreText)
	bg = nil
	gameOverText = nil
	continueText = nil
	scoreImg = nil
	scoreText = nil
	highscoreText = nil
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

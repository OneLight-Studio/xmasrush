-- Scene Home

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local menuNewGame
local menuHighScores
local menuHelp
local menuCredits

-- scene functions

function scene:createScene( event )
    local group = self.view
    bg = display.newImage( "img/bg.jpg" )
	menuNewGame = display.newImage( "img/home_newgame.png" )
	menuHighScores = display.newImage( "img/home_highscores.png" )
	menuHelp = display.newImage( "img/home_help.png" )
	menuCredits = display.newImage( "img/home_credits.png" )

	menuNewGame.x = display.contentWidth / 2
	menuNewGame.y = (display.contentHeight / 2 - menuNewGame.height * 1.8)
	menuHighScores.x = display.contentWidth / 2
	menuHighScores.y = (display.contentHeight / 2 - menuNewGame.height * 0.6)
	menuHelp.x = display.contentWidth / 2
	menuHelp.y = (display.contentHeight / 2 + menuNewGame.height * 0.6)
	menuCredits.x = display.contentWidth / 2
	menuCredits.y = (display.contentHeight / 2 + menuNewGame.height * 1.8)

	menuNewGame:addEventListener('tap', function ( event )
		moveToScene("scene_game")
	end)
	menuHighScores:addEventListener('tap', function ( event )
		moveToScene("scene_highscores")
	end)
	menuHelp:addEventListener('tap', function ( event )
		moveToScene("scene_help")
	end)
	menuCredits:addEventListener('tap', function ( event )
		moveToScene("scene_credits")
	end)

	group:insert( bg )
	group:insert( menuNewGame )
	group:insert( menuHighScores )
	group:insert( menuHelp )
	group:insert( menuCredits )
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	-- Nothing
end

function scene:exitScene( event )
	-- Nothing
end

function scene:destroyScene( event )
	-- Nothing
end

-- core

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
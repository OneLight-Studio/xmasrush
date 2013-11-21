-- Scene Game Over

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local gameOverText
local bg

-- scene functions

function scene:createScene( event )
    -- Nothing
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 100)
	gameOverText = display.newText(language:getString("game.over"), 0, 0, FONT, 60)
	gameOverText.x = display.contentWidth / 2
	gameOverText.y = display.contentHeight / 2

	bg:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)
end

function scene:exitScene( event )
	display.remove(bg)
	bg = nil
	display.remove(gameOverText)
	gameOverText = nil
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

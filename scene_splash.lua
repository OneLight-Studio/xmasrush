-- Scene Credits

-- constants

local DELAY_DISPLAY_HOME_SCREEN = 2000

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local splashImage

-- scene functions

function scene:createScene( event )
	local group = self.view
    splashImage = display.newImage("img/onelight.png")
	splashImage.x = display.contentWidth / 2 
	splashImage.y = display.contentHeight / 2
	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	group:insert(bg)
	group:insert(splashImage)
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	timer.performWithDelay(DELAY_DISPLAY_HOME_SCREEN, function() moveToSceneFade("scene_home") end)
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
-- Scene Game Pause

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local menuButton
local soundButton
local effectsButton
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
	menuButton = display.newImage("img/game_menu.png")
	menuButton.x = (display.contentWidth / 2 - menuButton.width * 2)
	menuButton.y = (display.contentHeight - menuButton.height) / 2
    soundButton = display.newImage("img/home_sound_on.png")
    soundButton.x = display.contentWidth / 2
	soundButton.y = (display.contentHeight - soundButton.height) / 2
    effectsButton = display.newImage("img/home_effects_on.png")
    effectsButton.x = (display.contentWidth / 2 + effectsButton.width * 2)
	effectsButton.y = (display.contentHeight - effectsButton.height) / 2

	menuButton:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

	bg:addEventListener("tap", function ( event )
		storyboard.hideOverlay()
	end)
end

function scene:exitScene( event )
	display.remove(bg)
	bg = nil
	display.remove(menuButton)
	menuButton = nil
	display.remove(soundButton)
	soundButton = nil
	display.remove(effectsButton)
	effectsButton = nil
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
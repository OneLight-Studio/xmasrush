-- Scene Credits

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local text
local menuButton

-- scene functions

function scene:createScene( event )
	local group = self.view

    bg = display.newImage( "img/bg.jpg" )
    text = display.newText("Credits", 100, 100, native.systemFont, 16)
	menuButton = display.newImage("img/game_menu.png")
	menuButton.x = menuButton.width / 2 + 5
	menuButton.y = menuButton.height / 2 + 5
	menuButton:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

	group:insert(bg)
	group:insert(menuButton)
	group:insert(text)
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
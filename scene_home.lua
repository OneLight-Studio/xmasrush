-- Scene Home


-- variables

local widget = require "widget"
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local nbBtn = 0

-- constants

local BTN_IMG = "img/btn.png"
local BTN_IMG_PRESSED = "img/btn_pressed.png"
local BTN_FONT_SIZE = 40
local BTN_LABEL_COLOR = { 44, 57, 130 }
local BTN_Y_MIN = 120
local BTN_VGAP = 70

-- local functions

local function addButton(title, scene)
	local btn = widget.newButton({
		defaultFile = BTN_IMG,
		overFile = BTN_IMG_PRESSED,
		label = title,
		labelColor = { default = BTN_LABEL_COLOR },
		font = FONT,
		fontSize = BTN_FONT_SIZE,
		onRelease = function(event)
			moveToScene(scene)
		end
	})
	btn.x = display.contentWidth / 2
	btn.y = BTN_Y_MIN + nbBtn * BTN_VGAP 
	nbBtn = nbBtn + 1
	return btn
end

-- scene functions

function scene:createScene( event )
    display.newImage(self.view, "img/bg.jpg" )
	display.newText({ parent=self.view, text="Xmas Rush", x=display.contentWidth / 2, y=30, font=FONT, fontSize=70 })
	self.view:insert(addButton("New Game", "scene_game"))
	self.view:insert(addButton("High Scores", "scene_highscores"))
	--self.view:insert(addButton("Help", "scene_help"))
	self.view:insert(addButton("Credits", "scene_credits"))
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

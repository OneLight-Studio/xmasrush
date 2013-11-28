-- Scene Game Finished

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local text
local img
local quitBtn
local nbBtn = 0

local BTN_Y_MIN = 250

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
		audio.play(audio.loadSound("sound/game_finished.mp3"))
	end

	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 180)

	text = display.newText(language:getString("game.finished"), 0, 0, FONT, 60)
	text.x = display.contentCenterX
	text.y = display.contentCenterY - 100

	img = display.newImage("img/game_paddle_gold.png")
	img.x = display.contentCenterX
	img.y = display.contentCenterY

	quitBtn = addButton(language:getString("menu.quit"), function() moveToScene("scene_home") end)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(text)
	display.remove(img)
	display.remove(quitBtn)
	bg = nil
	text = nil
	img = nil
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

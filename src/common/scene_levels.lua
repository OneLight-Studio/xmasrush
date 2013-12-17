-- Scene Levels

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local rect
local title
local closeBtn
local levelBtns = {}
local arcadeBtn

local LVL_COUNT = 10
local ROWS = 2
local LVL_PER_ROW = LVL_COUNT / ROWS
local TITLE_Y = 50
local TITLE_FONT_SIZE = 50
local BTN_X_MIN = BTN_SIZE / 2 + (display.contentWidth - LVL_PER_ROW * (BTN_SIZE + BTN_GAP)) / 2
local BTN_Y_MIN
if gameSettings.arcade then
	BTN_Y_MIN = TITLE_Y + 70
else
	BTN_Y_MIN = TITLE_Y + (display.contentHeight - ROWS * (BTN_SIZE + BTN_GAP)) / 2
end

-- local functions

local function addLevelButton(lvl, enabled)
	local btn = widget.newButton({
		defaultFile = enabled and BTN_SMALL_IMG or BTN_SMALL_IMG_DISABLED,
		overFile = enabled and BTN_SMALL_IMG_PRESSED or BTN_SMALL_IMG_DISABLED,
		label = "" .. lvl,
		labelColor = { default = enabled and BTN_LABEL_COLOR or BTN_LABEL_COLOR_DISABLED },
		font = FONT,
		fontSize = BTN_FONT_SIZE,
		onRelease = function()
			if enabled then
				moveToScene("standard.scene_game", { params = { level = lvl } })
			end
		end
	})
	local row = math.floor((lvl - 1) / LVL_PER_ROW)
	local col = (lvl - 1) % LVL_PER_ROW
	btn.x = BTN_X_MIN + col * (BTN_SIZE + BTN_GAP)
	btn.y = BTN_Y_MIN + row * (BTN_SIZE + BTN_GAP) 
	return btn
end

local function addArcadeButton()
	local btn = widget.newButton({
		defaultFile = BTN_IMG,
		overFile = BTN_IMG_PRESSED,
		label = language:getString("level.arcade"),
		labelColor = { default = BTN_LABEL_COLOR },
		font = FONT,
		fontSize = BTN_FONT_SIZE,
		onRelease = function()
			moveToScene("arcade.scene_game")
		end
	})
	btn.x = display.contentCenterX
	btn.y = display.contentHeight - 60
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
    bg = display.newImage( "img/bg.png" )
	bg.width = display.contentWidth
	bg.height = display.contentHeight
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY

	if gameSettings.arcade then
		BTN_Y_MIN = TITLE_Y + 70
	else
		BTN_Y_MIN = TITLE_Y + (display.contentHeight - ROWS * (BTN_SIZE + BTN_GAP)) / 2
	end

	closeBtn = display.newImageRect("img/close.png", 32, 32)
	closeBtn.x = display.contentWidth - 20
	closeBtn.y = 20
	closeBtn:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

	local startX = 15;
    rect = display.newRoundedRect( 15, 15, display.contentWidth - (startX*2), display.contentHeight - (startX*2), 17 )
	rect:setFillColor(0, 0, 0)
	rect.alpha = 0.6
	rect.strokeWidth = 3
	rect:setStrokeColor(180, 180, 180)

	title = display.newText(language:getString("levels"), 0, 0, FONT, TITLE_FONT_SIZE)
	title.x = display.contentCenterX
	title.y = TITLE_Y

	local level = gameSettings.level
	for i=1,10 do
		levelBtns[i] = addLevelButton(i, level and level >= i)
	end
	if gameSettings.arcade then
		arcadeBtn = addArcadeButton()
	end

	self.view:insert(bg)
	self.view:insert(rect)
	self.view:insert(closeBtn)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(rect)
	display.remove(title)
	display.remove(closeBtn)
	bg = nil
	rect = nil
	title = nil
	closeBtn = nil
	for i=1,10 do
		display.remove(levelBtns[i])
		levelBtns[i] = nil
	end
	display.remove(arcadeBtn)
	arcadeBtn = nil
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

-- Scene Game Pause

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local resumeBtn
local quitBtn
local soundBtn
local effectsBtn
local nbBtn = 0
local btnSmall = {}

-- constants

local BTN_Y_MIN = 100

-- local functions

local function updateBtnPosition()
	local nbBtnSmall = table.getn(btnSmall)
	local even = nbBtnSmall % 2 ~= 0
	for i, b in ipairs(btnSmall) do
		i = i - 0.5
		if i < nbBtnSmall / 2 then
			-- left
			b.x = display.contentWidth / 2 - (nbBtnSmall / 2 - i) * (BTN_SIZE + BTN_GAP)
		elseif i > nbBtnSmall / 2 then
			-- right
			b.x = display.contentWidth / 2 + (i - nbBtnSmall / 2) * (BTN_SIZE + BTN_GAP)
		else
			-- middle
			if even then
				b.x = display.contentWidth / 2
			else
				b.x = display.contentWidth / 2 - BTN_SIZE - BTN_GAP
			end
		end
	end
end

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
	btn.x = display.contentWidth / 2
	btn.y = BTN_Y_MIN + nbBtn * (BTN_SIZE + BTN_GAP)
	nbBtn = nbBtn + 1
	return btn
end

local function addButtonSmall(position, img, img_pressed, onTap)
	local btn = widget.newButton({
		defaultFile = img,
		overFile = img_pressed,
		onRelease = onTap
	})
	btn.y = BTN_Y_MIN + nbBtn * (BTN_SIZE + BTN_GAP) 
	btnSmall[position] = btn
	updateBtnPosition()
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
	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 100)

	resumeBtn = addButton(language:getString("menu.resume"), function(event) storyboard.hideOverlay() end)
	quitBtn = addButton(language:getString("menu.quit"), function(event) moveToScene("scene_home") end)

	soundBtn = addButtonSmall(1,
		gameSettings.soundEnable and "img/home_sound_on.png" or "img/home_sound_off.png", 
		gameSettings.soundEnable and "img/home_sound_on_pressed.png" or "img/home_sound_off_pressed.png", 
		soundListener)
	effectsBtn = addButtonSmall(2,
		gameSettings.soundEffectEnable and "img/home_effects_on.png" or "img/home_effects_off.png", 
		gameSettings.soundEffectEnable and "img/home_effects_on_pressed.png" or "img/home_effects_off_pressed.png", 
		effectSoundListener)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(resumeBtn)
	display.remove(quitBtn)
	display.remove(soundBtn)
	display.remove(effectsBtn)
	bg = nil
	resumeBtn = nil
	quitBtn = nil
	soundBtn = nil
	quitBtn = nil
end

function scene:destroyScene( event )
	-- Nothing
end


function soundListener ( event )
	gameSettings.soundEnable = not gameSettings.soundEnable
	display.remove(soundBtn)
	soundBtn = addButtonSmall(1,
		gameSettings.soundEnable and "img/home_sound_on.png" or "img/home_sound_off.png", 
		gameSettings.soundEnable and "img/home_sound_on_pressed.png" or "img/home_sound_off_pressed.png", 
		soundListener)
	loadsave.saveTable(gameSettings, GAME_SETTINGS)
end

function effectSoundListener ( event )
	gameSettings.soundEffectEnable = not gameSettings.soundEffectEnable
	display.remove(effectsBtn)
	effectsBtn = addButtonSmall(2,
		gameSettings.soundEffectEnable and "img/home_effects_on.png" or "img/home_effects_off.png", 
		gameSettings.soundEffectEnable and "img/home_effects_on_pressed.png" or "img/home_effects_off_pressed.png", 
		effectSoundListener)
	loadsave.saveTable(gameSettings, GAME_SETTINGS)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene

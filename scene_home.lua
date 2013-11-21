-- Scene Home


-- variables

local widget = require "widget"
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local nbBtn = 0
local btnSmall = {}
local soundBtn
local effectsBtn
local this

-- constants

local BTN_Y_MIN = 120

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
	print("" .. btn.height)
	btn.y = BTN_Y_MIN + nbBtn * (BTN_SIZE + BTN_GAP) 
	btnSmall[position] = btn
	updateBtnPosition()
	return btn
end

-- scene functions

function scene:createScene( event )
	this = self
    display.newImage(self.view, "img/bg.jpg" )
	display.newText({ parent=self.view, text="Xmas Rush", x=display.contentWidth / 2, y=30, font=FONT, fontSize=70 })
	self.view:insert(addButton("New Game", function(event) moveToScene("scene_game") end))
	self.view:insert(addButton("High Scores", function(event) moveToScene("scene_highscores") end))
	self.view:insert(addButtonSmall(1, "img/home_help.png", "img/home_help_pressed.png", function(event) moveToScene("scene_help") end))
	self.view:insert(addButtonSmall(2, "img/home_credits.png", "img/home_credits_pressed.png", function(event) moveToScene("scene_credits") end))
	soundBtn = addButtonSmall(3,
		gameSettings.soundEnable and "img/home_sound_on.png" or "img/home_sound_off.png", 
		gameSettings.soundEnable and "img/home_sound_on_pressed.png" or "img/home_sound_off_pressed.png", 
		self.soundListener)
	effectsBtn = addButtonSmall(4,
		gameSettings.soundEffectEnable and "img/home_effects_on.png" or "img/home_effects_off.png", 
		gameSettings.soundEffectEnable and "img/home_effects_on_pressed.png" or "img/home_effects_off_pressed.png", 
		self.effectSoundListener)
	self.view:insert(soundBtn)
	self.view:insert(effectsBtn)
end

function scene:soundListener ( event )
	gameSettings.soundEnable = not gameSettings.soundEnable
	display.remove(soundBtn)
	soundBtn = addButtonSmall(3,
		gameSettings.soundEnable and "img/home_sound_on.png" or "img/home_sound_off.png", 
		gameSettings.soundEnable and "img/home_sound_on_pressed.png" or "img/home_sound_off_pressed.png", 
		this.soundListener)
	this.view:insert(soundBtn)
	loadsave.saveTable(gameSettings, "crazyxmas.json")
end

function scene:effectSoundListener ( event )
	gameSettings.soundEffectEnable = not gameSettings.soundEffectEnable
	display.remove(effectsBtn)
	effectsBtn = addButtonSmall(4,
		gameSettings.soundEffectEnable and "img/home_effects_on.png" or "img/home_effects_off.png", 
		gameSettings.soundEffectEnable and "img/home_effects_on_pressed.png" or "img/home_effects_off_pressed.png", 
		this.effectSoundListener)
	this.view:insert(effectsBtn)
	loadsave.saveTable(gameSettings, "crazyxmas.json")
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

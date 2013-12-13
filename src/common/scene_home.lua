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
local audioLoop
local audioChannel

local mRand = math.random; math.randomseed( os.time())
local xGravity, yGravity, xWind, yWind = 0, 18, 10, 2
local snow

-- constants

local BTN_Y_MIN = 150
if gameSettings.arcade then
	BTN_Y_MIN = 130
end

-- local functions
local function updateBtnPosition()
	local nbBtnSmall = #btnSmall
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

local function setupSoundBtn()
	soundBtn = addButtonSmall(3,
		gameSettings.soundEnable and "img/home_sound_on.png" or "img/home_sound_off.png", 
		gameSettings.soundEnable and "img/home_sound_on_pressed.png" or "img/home_sound_off_pressed.png", 
		this.soundListener)
	this.view:insert(soundBtn)
end

local function setupEffectsBtn()
	effectsBtn = addButtonSmall(4,
		gameSettings.soundEffectEnable and "img/home_effects_on.png" or "img/home_effects_off.png", 
		gameSettings.soundEffectEnable and "img/home_effects_on_pressed.png" or "img/home_effects_off_pressed.png", 
		this.effectSoundListener)
	this.view:insert(effectsBtn)
end

local function playAudioLoop()
	audio.setVolume(0.3)
	audioChannel = audio.play(audioLoop, { channel = 1, loops = -1 })
	al.Source(audio.getSourceFromChannel(1), al.PITCH, 1)
	if not gameSettings.soundEnable then
		audio.pause(audioChannel)
	end
end

local function animateSnow (event)
	if snow then
        for i=1, snow.numChildren do
                local flake = snow[i]
                flake:translate((flake.xVelocity+xWind)*0.1,(flake.yVelocity+yWind)*0.1)
                if flake.y > display.contentHeight then
                        flake.x, flake.y = mRand(display.contentWidth),mRand(60)
                end
        end
        if mRand(100) == 1 then xWind = 0-xWind; end
    end
end

local function initSnow(snowCount)
    for i=1,snowCount do
            local flake = display.newImageRect(snow,"img/snowflake.png",16,16)
            --if mRand(1,2) == 1 then flake.alpha = mRand(25,50) * .01; end
            flake.alpha = mRand(25,75) * .01
            flake.x, flake.y = mRand(display.contentWidth), mRand(display.contentHeight)
            flake.yVelocity, flake.xVelocity = mRand(50), mRand(50)
    end
end

-- scene functions

function scene:createScene( event )
	this = self
    display.newImage(self.view, "img/bg.jpg" )
	display.newText({ parent=self.view, text=language:getString("game.name"), x=display.contentWidth / 2, y=50, font=FONT, fontSize=70 })
	self.view:insert(addButton(language:getString("menu.play"), function(event) moveToScene("scene_levels") end))
	self.view:insert(addButton(language:getString("menu.scores"), function(event) moveToScene("scene_highscores") end))
	self.view:insert(addButtonSmall(1, "img/home_help.png", "img/home_help_pressed.png", function(event) moveToScene("scene_help") end))
	self.view:insert(addButtonSmall(2, "img/home_credits.png", "img/home_credits_pressed.png", function(event) moveToScene("scene_credits") end))
	setupSoundBtn()
	setupEffectsBtn()

	audioLoop = audio.loadSound("sound/menu.mp3")
	playAudioLoop()
end

function scene:soundListener ( event )
	gameSettings.soundEnable = not gameSettings.soundEnable
	display.remove(soundBtn)
	setupSoundBtn()
	loadsave.saveTable(gameSettings, GAME_SETTINGS)
	if gameSettings.soundEnable then
		audio.resume(audioChannel)
	else
		audio.pause(audioChannel)
	end
end

function scene:effectSoundListener ( event )
	gameSettings.soundEffectEnable = not gameSettings.soundEffectEnable
	display.remove(effectsBtn)
	setupEffectsBtn()
	loadsave.saveTable(gameSettings, GAME_SETTINGS)
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	display.remove(soundBtn)
	display.remove(effectsBtn)
	setupSoundBtn()
	setupEffectsBtn()

	if not audio.isChannelPlaying(audioChannel) then
		playAudioLoop()
	end

	snow = display.newGroup()
	initSnow(50)
	Runtime:addEventListener("enterFrame",animateSnow)
end

function scene:exitScene( event )
	display.remove(snow)
	snow = nil
	Runtime:removeEventListener("enterFrame",animateSnow)
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

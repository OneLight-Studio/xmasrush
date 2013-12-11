-- Main
display.setStatusBar(display.HiddenStatusBar)

require "src.helper"

-- global constants

LEVELS = { 50, 100, 200, 400, 600, 850, 1100, 1400, 1700, 2000 }
FONT = "Cartoon"
BTN_IMG = "img/btn.png"
BTN_IMG_PRESSED = "img/btn_pressed.png"
BTN_SMALL_IMG = "img/btn_small.png"
BTN_SMALL_IMG_PRESSED = "img/btn_small_pressed.png"
BTN_SMALL_IMG_DISABLED = "img/btn_small_disabled.png"
BTN_FONT_SIZE = 40
BTN_LABEL_COLOR = { 44, 57, 130 }
BTN_LABEL_COLOR_DISABLED = { 47, 57 , 130, 150 }
BTN_SIZE = 60
BTN_GAP = 10
GAME_SETTINGS = "xmasrush.json"
MAX_HIGHSCORES = 10

-- variables

local storyboard = require "storyboard"

-- global variables

loadsave = require("src.loadsave")
gameSettings = loadsave.loadTable(GAME_SETTINGS)
language = require("src.rosetta").new()


-- functions

function moveToScene(name, params)
	storyboard.gotoScene("src." .. name, params)
end

function moveToSceneFade(name)
	storyboard.gotoScene("src." .. name,"fade", 1000)
end

function moveToOverlay(name, params)
	storyboard.showOverlay("src." .. name, params)
end

	-- Android specific
function onKeyEvent(event)
	local keyName = event.keyName

   	if "back" == keyName then
		if storyboard.getCurrentSceneName() ~= "scene_home" then
			return true
		end
	end

	return false
end

-- core

language:initiate()
language:setCurrentLanguage(system.getPreference( "locale", "language" ))

if( gameSettings == nil ) then
    -- There are no settings. This is first time the user launch your game
    -- Create the default settings
    gameSettings = {}
	gameSettings.finished = false
    gameSettings.level = 1
    gameSettings.highScore = 0
    gameSettings.soundEnable = true
    gameSettings.soundEffectEnable = true
	gameSettings.tuto = {}

    loadsave.saveTable(gameSettings, GAME_SETTINGS)
end

Runtime:addEventListener( "key", onKeyEvent )

moveToSceneFade("scene_splash")

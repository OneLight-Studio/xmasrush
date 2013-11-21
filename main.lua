-- Main
display.setStatusBar(display.HiddenStatusBar)

require "helper"

display.setStatusBar(display.HiddenStatusBar)

-- global constants

FONT = "Cartoon"
BTN_IMG = "img/btn.png"
BTN_IMG_PRESSED = "img/btn_pressed.png"
BTN_SMALL_IMG = "img/btn_small.png"
BTN_SMALL_IMG_PRESSED = "img/btn_small_pressed.png"
BTN_FONT_SIZE = 40
BTN_LABEL_COLOR = { 44, 57, 130 }
BTN_SIZE = 60
BTN_GAP = 10

-- variables

local storyboard = require "storyboard"

-- global variables

loadsave = require("loadsave")
gameSettings = loadsave.loadTable("crazyxmas.json")

-- functions

function moveToScene(name)
	storyboard.gotoScene(name)
end

function moveToSceneFade(name)
	storyboard.gotoScene(name,"fade", 1000)
end

-- core

if( gameSettings == nil ) then
    -- There are no settings. This is first time the user launch your game
    -- Create the default settings
    gameSettings = {}
    gameSettings.highScore = 0
    gameSettings.soundEnable = true
    gameSettings.soundEffectEnable = true

    loadsave.saveTable(gameSettings, "crazyxmas.json")
end


moveToSceneFade("scene_splash")

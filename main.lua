-- Main
display.setStatusBar(display.HiddenStatusBar)

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
-- Main
display.setStatusBar(display.HiddenStatusBar)

require "helper"

-- variables

local storyboard = require "storyboard"

-- global variables

loadsave = require("loadsave")
gameSettings = loadsave.loadTable("crazyxmas.json")
language = require("rosetta").new()


-- functions

function moveToScene(name)
	storyboard.gotoScene(name)
end

function moveToSceneFade(name)
	storyboard.gotoScene(name,"fade", 1000)
end

-- core

language:initiate()
language:setCurrentLanguage(system.getPreference( "locale", "language" ))

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

-- Scene Game Pause

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local menuButton
local soundButton
local effectsButton
local bg

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
	menuButton = display.newImage("img/game_menu.png")
	menuButton.x = (display.contentWidth / 2 - menuButton.width * 2)
	menuButton.y = (display.contentHeight - menuButton.height) / 2

	if gameSettings.soundEnable then
    	soundButton = display.newImage("img/home_sound_on.png")
	else
    	soundButton = display.newImage("img/home_sound_off.png")
	end
    soundButton.x = display.contentWidth / 2
	soundButton.y = (display.contentHeight - soundButton.height) / 2

	if gameSettings.soundEffectEnable then
    	effectsButton = display.newImage("img/home_effects_on.png")
	else
    	effectsButton = display.newImage("img/home_effects_off.png")
	end
    effectsButton.x = (display.contentWidth / 2 + effectsButton.width * 2)
	effectsButton.y = (display.contentHeight - effectsButton.height) / 2

	resumeButton = display.newImage("img/game_pause_resume.png")
    resumeButton.x = display.contentWidth / 2 
	resumeButton.y = (display.contentHeight + (resumeButton.height * 2)) / 2

	menuButton:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

	soundButton:addEventListener("tap",  soundListener)
	effectsButton:addEventListener("tap",  effectSoundListener)

	resumeButton:addEventListener("tap", function ( event )
		storyboard.hideOverlay()
	end)
end

function scene:exitScene( event )
	display.remove(bg)
	bg = nil
	display.remove(menuButton)
	menuButton = nil
	display.remove(soundButton)
	soundButton = nil
	display.remove(effectsButton)
	effectsButton = nil
	display.remove(resumeButton)
	resumeButton = nil
end

function scene:destroyScene( event )
	-- Nothing
end


function soundListener ( event )
	if gameSettings.soundEnable then
		gameSettings.soundEnable = false
		-- hide the object
		soundButton.isVisible = false
		-- remove it
		display.remove(soundButton)
		soundButton = nil
		soundButton = display.newImage("img/home_sound_off.png")
		soundButton.x = display.contentWidth / 2
		soundButton.y = (display.contentHeight - soundButton.height) / 2
		soundButton.isVisible = true
		soundButton:addEventListener( "tap", soundListener )
	else
		gameSettings.soundEnable = true
		soundButton.isVisible = false
		display.remove(soundButton)
		soundButton = nil
		soundButton = display.newImage("img/home_sound_on.png")
		soundButton.x = display.contentWidth / 2
		soundButton.y = (display.contentHeight - soundButton.height) / 2
		soundButton.isVisible = true
		soundButton:addEventListener( "tap", soundListener )
	end
	loadsave.saveTable(gameSettings, "crazyxmas.json")
end

function effectSoundListener ( event )
	if gameSettings.soundEffectEnable then
		gameSettings.soundEffectEnable = false
		-- hide the object
		effectsButton.isVisible = false
		-- remove it
		display.remove(effectsButton)
		effectsButton = nil
		effectsButton = display.newImage("img/home_effects_off.png")
    	effectsButton.x = (display.contentWidth / 2 + effectsButton.width * 2)
		effectsButton.y = (display.contentHeight - effectsButton.height) / 2
		effectsButton.isVisible = true
		effectsButton:addEventListener( "tap", effectSoundListener )
	else
		gameSettings.soundEffectEnable = true
		effectsButton.isVisible = false
		display.remove(effectsButton)
		effectsButton = nil
		effectsButton = display.newImage("img/home_effects_on.png")
    	effectsButton.x = (display.contentWidth / 2 + effectsButton.width * 2)
		effectsButton.y = (display.contentHeight - effectsButton.height) / 2
		effectsButton.isVisible = true
		effectsButton:addEventListener( "tap", effectSoundListener )
	end
	loadsave.saveTable(gameSettings, "crazyxmas.json")
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
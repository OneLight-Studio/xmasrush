-- Main

require "helper"

-- variables

local storyboard = require "storyboard"

-- functions

function moveToScene(name)
	storyboard.gotoScene(name)
end

-- core

moveToScene("scene_home")
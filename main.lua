-- constants

local PADDLE_WIDTH = 128
local PADDLE_HEIGHT = 64
local PADDLE_IMG = "img/paddle.png"
local PRESENT_SIZE = 32
local PRESENT_IMG = "img/present.png"
local DELAY_BETWEEN_PRESENTS_MIN = 300
local DELAY_BETWEEN_PRESENTS_MODIFIER = 10

-- variables

local physics = require("physics")
local delayBetweenPresents = 1000
local paddle

-- functions

function newPaddle()
	local paddle = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
	paddle.x = display.contentCenterX
	paddle.y = display.contentHeight - paddle.height / 2
end

function newPresent()
	local present = display.newImageRect(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE)
	return present
end

function dropItem(item)
	item.x = math.random(item.width / 2, display.contentWidth - item.width / 2)
	item.y = -item.height / 2
	physics.addBody(item, "dynamic")
end

function dropPresent()
	dropItem(newPresent())
	delayBetweenPresents = math.max(500, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)
	timer.performWithDelay(delayBetweenPresents, dropPresent)
end

-- main

math.randomseed(os.time())
display.setStatusBar(display.HiddenStatusBar)
physics.start()
paddle = newPaddle()
dropPresent()

-- constants

local PADDLE_WIDTH = 128
local PADDLE_HEIGHT = 64
local PADDLE_IMG = "img/paddle.png"
local PRESENT_SIZE = 32
local PRESENT_IMG = "img/present.png"
local PRESENT_MIN_SPEED = 1
local PRESENT_MAX_SPEED = 8
local DELAY_BETWEEN_PRESENTS_MIN = 300
local DELAY_BETWEEN_PRESENTS_MODIFIER = 10
local SCORE_TEXT = "Score "
local SCORE_WIDTH = 80
local LIVES_START = 10
local LIVES_TEXT = "Vies "
local LIVES_WIDTH = 40

-- variables

local delayBetweenPresents = 1000
local paddle
local items = {}
local score
local scoreLabel
local lives
local livesLabel

-- functions

local function updateScore()
	display.remove(scoreLabel)
	scoreLabel = display.newText(SCORE_TEXT .. score, display.contentWidth - SCORE_WIDTH, 0)
end

local function updateLives()
	display.remove(livesLabel)
	livesLabel = display.newText(LIVES_TEXT .. lives, display.contentCenterX - LIVES_WIDTH / 2, 0)
end

local function catchPresent()
	score = score + 1
	updateScore()
end

local function missPresent()
	lives = lives - 1
	updateLives()
end

local function newPaddle()
	local paddle = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
	paddle.x = display.contentCenterX
	paddle.y = display.contentHeight - paddle.height / 2
	return paddle
end

local function newPresent()
	local present = display.newImageRect(PRESENT_IMG, PRESENT_SIZE, PRESENT_SIZE)
	present.speed = math.random(PRESENT_MIN_SPEED, PRESENT_MAX_SPEED)
	present.catchFunction = catchPresent
	present.missFunction = missPresent
	return present
end

local function dropItem(item)
	table.insert(items, item)
	-- drop the item randomly on the x-axis
	item.x = math.random(item.width / 2, display.contentWidth - item.width / 2)
	item.y = -item.height / 2
end

local function dropPresent()
	dropItem(newPresent())
	delayBetweenPresents = math.max(500, delayBetweenPresents - DELAY_BETWEEN_PRESENTS_MODIFIER)
	timer.performWithDelay(delayBetweenPresents, dropPresent)
end

-- events

local function onTouch(event)
	if event.phase == "began" then
		local paddleBounds = paddle.contentBounds
		if event.x >= paddleBounds.xMin and event.x <= paddleBounds.xMax and event.y >= paddleBounds.yMin and event.y <= paddleBounds.yMax then
			paddle.focused = true
			paddle.touchOffset = event.x - paddle.x
		end
	elseif event.phase == "moved" and paddle.focused then
		local newX = event.x - paddle.touchOffset
		if newX - paddle.width / 2 < 0 then
			newX = paddle.width / 2
		end
		if newX + paddle.width / 2 > display.contentWidth then
			newX = display.contentWidth - paddle.width / 2
		end
		paddle.x = newX
	else
		paddle.focused = false
	end
end

local function onEveryFrame(event)
	-- move each item
	for i, item in pairs(items) do
		item:translate(0, item.speed)
		local itemBounds = item.contentBounds
		local paddleBounds = paddle.contentBounds
		-- remove the item if it is in the box
		if itemBounds.xMin >= paddleBounds.xMin and itemBounds.xMax <= paddleBounds.xMax and itemBounds.yMax >= paddleBounds.yMin then
			table.remove(items, i)
			display.remove(item)
			item.catchFunction()
		-- remove the item if it is out of the screen
		elseif itemBounds.yMin > display.contentHeight then
			table.remove(items, i)
			display.remove(item)
			item.missFunction()
		end
	end
	-- keep the test visible
	scoreLabel:toFront()
	livesLabel:toFront()
end

-- init
math.randomseed(os.time())
display.setStatusBar(display.HiddenStatusBar)

-- listeners
Runtime:addEventListener("touch", onTouch)
Runtime:addEventListener("enterFrame", onEveryFrame)

-- start
paddle = newPaddle()
score = 0
lives = LIVES_START
updateScore()
updateLives()
dropPresent()

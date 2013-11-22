-- Scene Hightscores

-- variables

local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local rect
local closeBtn
local labels = {}
local scores = {}

-- scene functions

function scene:createScene( event )
	-- Nothing
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
    bg = display.newImage( "img/bg.jpg" )

	closeBtn = display.newImageRect("img/close.png", 32, 32)
	closeBtn.x = display.contentWidth - 20
	closeBtn.y = 20
	closeBtn:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

	local startX = 15;
    rect = display.newRoundedRect( 15, 15, display.contentWidth - (startX*2), display.contentHeight - (startX*2), 17 )
	rect:setFillColor(0, 0, 0)
	rect.alpha = 0.6
	rect.strokeWidth = 3
	rect:setStrokeColor(180, 180, 180)

	local highscores = gameSettings.highscores
	for i = 1,MAX_HIGHSCORES do
		local score = "-"
		if highscores and highscores[i] then
			score = highscores[i] .. language:getString("pts")
		end
		labels[i] = display.newText(i .. ".", display.contentCenterX - 50, i * 25, FONT, 20)
		scores[i] = display.newText(score, display.contentCenterX + 10, i * 25, FONT, 20)
	end

	self.view:insert(bg)
	self.view:insert(rect)
	self.view:insert(closeBtn)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(rect)
	display.remove(closeBtn)
	bg = nil
	rect = nil
	closeBtn = nil
	for i,text in ipairs(labels) do
		display.remove(text)
		text = nil
	end
	for i,text in ipairs(scores) do
		display.remove(text)
		text = nil
	end
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

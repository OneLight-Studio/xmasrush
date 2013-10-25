require 'class'

local PADDLE_WIDTH = 128
local PADDLE_HEIGHT = 64
local PADDLE_IMG = "img/paddle.png"

Paddle = class(function(paddleI, score, lives)
	local pad

	paddleI.paddle = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
	pad = paddleI.paddle
	pad.x = display.contentCenterX
	pad.y = display.contentHeight - pad.height / 2

	Runtime:addEventListener("touch",  function (event)
		if event.phase == "began" then
			local paddleBounds = pad.contentBounds
			if event.x >= paddleBounds.xMin and event.x <= paddleBounds.xMax and event.y >= paddleBounds.yMin and event.y <= paddleBounds.yMax then
				pad.focused = true
				pad.touchOffset = event.x - pad.x
			end
		elseif event.phase == "moved" and pad.focused then
			local newX = event.x - pad.touchOffset
			if newX - pad.width / 2 < 0 then
				newX = pad.width / 2
			end
			if newX + pad.width / 2 > display.contentWidth then
				newX = display.contentWidth - pad.width / 2
			end
			pad.x = newX
		else
			pad.focused = false
		end
	end)
end)

function Paddle:contentBounds()
	return self.paddle.contentBounds
end
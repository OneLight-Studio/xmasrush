require 'class'

local PADDLE_WIDTH = 128
local PADDLE_HEIGHT = 64
local PADDLE_IMG = "img/paddle.png"

Paddle = class(function(this, score, lives)
	local pad

	this.paddle = display.newImageRect(PADDLE_IMG, PADDLE_WIDTH, PADDLE_HEIGHT)
	pad = this.paddle
	pad.x = display.contentCenterX
	pad.y = display.contentHeight - pad.height / 2

	Runtime:addEventListener("touch",  function (event)
		local newX = event.x
		if newX - pad.width / 2 < 0 then
			newX = pad.width / 2
		end
		if newX + pad.width / 2 > display.contentWidth then
			newX = display.contentWidth - pad.width / 2
		end
		if event.phase == "began" then
			pad.transition = transition.to(pad, { x=newX, time=250, transition=easing.inOutExpo })
		elseif event.phase == "moved" then
			transition.cancel(pad.transition)
			pad.x = newX
		end
	end)
end)

function Paddle:contentBounds()
	return self.paddle.contentBounds
end

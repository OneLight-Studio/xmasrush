function isBoundsInBounds(bounds1, bounds2)
	if 
		((bounds1.xMin > bounds2.xMin and bounds1.xMin < bounds2.xMax) or
		(bounds1.xMax > bounds2.xMin and bounds1.xMax < bounds2.xMax)) and
		((bounds1.yMin > bounds2.yMin and bounds1.yMin < bounds2.yMax) or
		(bounds1.yMax > bounds2.yMin and bounds1.yMax < bounds2.yMax))
	then
		return true
	end

	return false
end

function showBounds(bounds, lastRectBounds)
	local rectBounds = {}

	if lastRectBounds ~= nil then
		display.remove(lastRectBounds.boundsLeftTop)
		display.remove(lastRectBounds.boundsRightTop)
		display.remove(lastRectBounds.boundsRightBottom)
		display.remove(lastRectBounds.boundsLeftBottom)
	end

	rectBounds.boundsLeftTop = display.newRect(bounds.xMin, bounds.yMin, 5, 5)
	rectBounds.boundsLeftTop:setFillColor(0, 0, 255)
	rectBounds.boundsRightTop = display.newRect(bounds.xMax, bounds.yMin, 5, 5)
	rectBounds.boundsRightTop:setFillColor(0, 0, 255)
	rectBounds.boundsRightBottom = display.newRect(bounds.xMax, bounds.yMax, 5, 5)
	rectBounds.boundsRightBottom:setFillColor(0, 0, 255)
	rectBounds.boundsLeftBottom = display.newRect(bounds.xMin, bounds.yMax, 5, 5)
	rectBounds.boundsLeftBottom:setFillColor(0, 0, 255)

	return rectBounds
end

BLINK_SPEED_FAST = 'blink_fast'
BLINK_SPEED_NORMAL = 'blink_normal'
BLINK_SPEED_SLOW = 'blink_slow'

function blink(element, speed)
	local iteration
	local delay

	if speed == BLINK_SPEED_FAST then
		iteration = 10
		delay = 50
	elseif speed == BLINK_SPEED_NORMAL then
		iteration = 20
		delay = 100
	elseif speed == BLINK_SPEED_SLOW then
		iteration = 10
		delay = 200
	end

	timer.performWithDelay(delay, function()
		if element ~= nil and element.alpha ~= nil then
			element.alpha = element.alpha < 1 and 1 or 0
		end
	end, iteration)
end
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
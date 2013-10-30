require 'class'

PRESENT_SIZE = 32
PRESENT_IMG = "img/present.png"
PRESENT_MIN_SPEED = 1
PRESENT_MAX_SPEED = 8

Item = class(function(this, img, width, height, minSpeed, maxSpeed, scoreBonus, lifeMalus)
	this.element = display.newImageRect(img, width, height)
	this.width = width
	this.height = height
	this.speed = math.random(minSpeed, maxSpeed)
	this.scoreBonus = scoreBonus
	this.lifeMalus = lifeMalus

	this.element.x = math.random(this.element.width / 2, display.contentWidth - this.element.width / 2)
	this.element.y = -this.element.height / 2
end)

function Item:contentBounds()
	return self.element.contentBounds
end

function Item:startTranslate()
	self.element:translate(0, self.speed)
end

function Item:remove()
	display.remove(self.element)
end
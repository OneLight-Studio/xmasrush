require 'class'

PRESENT_SIZE = 32
PRESENT_IMG = "img/present.png"
PRESENT_MIN_SPEED = 1
PRESENT_MAX_SPEED = 8
PRESENT_SOUND = audio.loadSound("sound/blop.mp3")

BOMB_SIZE = 32
BOMB_IMG = "img/bomb.png"
BOMB_MIN_SPEED = 3
BOMB_MAX_SPEED = 6
BOMB_SOUND = audio.loadSound("sound/bomb.wav")

LIFE_SIZE = 32
LIFE_IMG = "img/life.png"
LIFE_MIN_SPEED = 6
LIFE_MAX_SPEED = 10
LIFE_SOUND = audio.loadSound("sound/life_up.mp3")

Item = class(function(this, img, width, height, minSpeed, maxSpeed, hit, fall, sound)
	this.element = display.newImageRect(img, width, height)
	this.width = width
	this.height = height
	this.speed = math.random(minSpeed, maxSpeed)
	this.scoreBonus = scoreBonus
	this.hit = hit
	this.fall = fall
	this.sound = sound

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

function Item:onHit(game)
	if self.hit then
		self.hit()
	end
	if self.sound then
		audio.play(self.sound)
	end
end

function Item:onFall(game)
	if self.fall then
		self.fall()
	end
end

-- Item

require 'class'

-- constants

PRESENT_SIZE = 32
PRESENT_IMG = "img/game_present_#index#.png"
PRESENT_IMG_INDEX_MIN = 1
PRESENT_IMG_INDEX_MAX = 8
PRESENT_MIN_SPEED = 2
PRESENT_MAX_SPEED = 4
PRESENT_SOUND = audio.loadSound("sound/blop.mp3")

BOMB_SIZE = 32
BOMB_IMG = "img/game_bomb_2.png"
BOMB_MIN_SPEED = 3
BOMB_MAX_SPEED = 3
BOMB_SOUND = audio.loadSound("sound/bomb.wav")

LIFE_SIZE = 32
LIFE_IMG = "img/game_life_2.png"
LIFE_MIN_SPEED = 6
LIFE_MAX_SPEED = 6
LIFE_SOUND = audio.loadSound("sound/life_up.mp3")

STAR_SIZE = 32
STAR_IMG = "img/game_star.png"
STAR_MIN_SPEED = 7
STAR_MAX_SPEED = 7

-- variables

-- functions

-- core

Item = class(function(this, img, width, height, minSpeed, maxSpeed, hit, fall, sound)
	this.img = img
	if string.find(this.img, '#index#') ~= nil then
		this.img = string.gsub(this.img, '#index#', math.random(PRESENT_IMG_INDEX_MIN, PRESENT_IMG_INDEX_MAX))
	end
	this.width = width
	this.height = height
	this.speed = math.random(minSpeed, maxSpeed)
	this.scoreBonus = scoreBonus
	this.hit = hit
	this.fall = fall
	this.sound = sound
end)

function Item:onEnterScene(x, y)
	self.element = display.newImageRect(self.img, self.width, self.height)
	if x ~= nil and y ~= nil then
		self.element.x = x
		self.element.y = y
	else
		self.element.x = math.random(self.element.width / 2, display.contentWidth - self.element.width / 2)
		self.element.y = -self.element.height / 2
	end
end

function Item:onExitScene()
	display.remove(self.element)
	self.element = nil
end

function Item:contentBounds()
	if self.element ~= nil then
		return self.element.contentBounds
	end
	
	return nil
end

function Item:startTranslate()
	if self.element ~= nil then
		self.element:translate(0, self.speed)
	end
end

function Item:remove()
	self:onExitScene()
end

function Item:onHit(game)
	if self.hit then
		self.hit()
	end
	if self.sound and gameSettings.soundEffectEnable then
		audio.play(self.sound)
	end
end

function Item:onFall(game)
	if self.fall then
		self.fall()
	end
end
-- Item

require 'class'

-- constants

TYPE_PRESENT = 'present'
TYPE_BOMB = 'bomb'
TYPE_IMP = 'imp'
TYPE_STAR_BONUS = 'star'
TYPE_STAR_PRESENT = 'star_present'
TYPE_IMP_BONUS = 'imp_bonus'
TYPE_LIFE_BONUS = 'life'
TYPE_ASPIRATOR_BONUS = 'aspirator'

PRESENT_IMG = "img/game_present_#index#.png"
PRESENT_IMG_INDEX_MIN = 1
PRESENT_IMG_INDEX_MAX = 8
PRESENT_WIDTH = 32
PRESENT_HEIGHT = 32
PRESENT_MIN_SPEED = 2
PRESENT_MAX_SPEED = 4
PRESENT_SOUND = audio.loadSound("sound/blop.mp3")

BOMB_IMG = "img/game_bomb_2.png"
BOMB_WIDTH = 32
BOMB_HEIGHT = 32
BOMB_MIN_SPEED = 3
BOMB_MAX_SPEED = 3
BOMB_SOUND = audio.loadSound("sound/bomb.wav")

LIFE_BONUS_IMG = "img/game_life_2.png"
LIFE_BONUS_WIDTH = 32
LIFE_BONUS_HEIGHT = 32
LIFE_BONUS_MIN_SPEED = 6
LIFE_BONUS_MAX_SPEED = 6
LIFE_BONUS_SOUND = audio.loadSound("sound/life_up.mp3")

STAR_BONUS_IMG = "img/game_star.png"
STAR_BONUS_WIDTH = 32
STAR_BONUS_HEIGHT = 32
STAR_BONUS_MIN_SPEED = 7
STAR_BONUS_MAX_SPEED = 7
STAR_BONUS_PRESENT_MIN_SPEED = 7
STAR_BONUS_PRESENT_MAX_SPEED = 7

IMP_WIDTH = 100
IMP_HEIGHT = 101
IMP_IMG = "img/game_imp.png"
IMP_MIN_SPEED = 0
IMP_MAX_SPEED = 0

IMP_BONUS_WIDTH = 63
IMP_BONUS_HEIGHT = 64
IMP_BONUS_IMG = "img/game_imp_bonus.png"
IMP_BONUS_MIN_SPEED = 7
IMP_BONUS_MAX_SPEED = 7

-- variables

local currentShowBounds

-- functions

-- core

Item = class(function(this, type, hit, fall)
	this.type = type

	if type == TYPE_PRESENT then
		this.img = string.gsub(PRESENT_IMG, '#index#', math.random(PRESENT_IMG_INDEX_MIN, PRESENT_IMG_INDEX_MAX))
		this.width = PRESENT_WIDTH
		this.height = PRESENT_HEIGHT
		this.speed = math.random(PRESENT_MIN_SPEED, PRESENT_MAX_SPEED)
		this.sound = PRESENT_SOUND
	elseif type == TYPE_STAR_PRESENT then
		this.img = string.gsub(PRESENT_IMG, '#index#', math.random(PRESENT_IMG_INDEX_MIN, PRESENT_IMG_INDEX_MAX))
		this.width = PRESENT_WIDTH
		this.height = PRESENT_HEIGHT
		this.speed = math.random(STAR_BONUS_PRESENT_MIN_SPEED, STAR_BONUS_PRESENT_MAX_SPEED)
	elseif type == TYPE_BOMB then
		this.img = BOMB_IMG
		this.width = BOMB_WIDTH
		this.height = BOMB_HEIGHT
		this.speed = math.random(BOMB_MIN_SPEED, BOMB_MAX_SPEED)
		this.sound = BOMB_SOUND
	elseif type == TYPE_IMP then
		this.img = IMP_IMG
		this.width = IMP_WIDTH
		this.height = IMP_HEIGHT
		this.speed = 0

	-- Bonus

	elseif type == TYPE_STAR_BONUS then
		this.img = STAR_BONUS_IMG
		this.width = STAR_BONUS_WIDTH
		this.height = STAR_BONUS_HEIGHT
		this.speed = math.random(BOMB_MIN_SPEED, PRESENT_MAX_SPEED)
	elseif type == TYPE_LIFE_BONUS then
		this.img = LIFE_BONUS_IMG
		this.width = LIFE_BONUS_WIDTH
		this.height = LIFE_BONUS_HEIGHT
		this.speed = math.random(LIFE_BONUS_MIN_SPEED, LIFE_BONUS_MAX_SPEED)
		this.sound = LIFE_BONUS_SOUND
	elseif type == TYPE_IMP_BONUS then
		this.img = IMP_BONUS_IMG
		this.width = IMP_BONUS_WIDTH
		this.height = IMP_BONUS_HEIGHT
		this.speed = math.random(IMP_BONUS_MIN_SPEED, IMP_BONUS_MAX_SPEED)
	elseif type == TYPE_ASPIRATOR then

	end

	this.hit = hit
	this.fall = fall
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
		if self.img == IMP_IMG then
			local currentBounds = self.element.contentBounds
			local bounds = {}
			bounds.xMin = currentBounds.xMin
			bounds.xMax = currentBounds.xMax - 10
			bounds.yMin = currentBounds.yMin + 40
			bounds.yMax = currentBounds.yMax

			--currentShowBounds = showBounds(bounds, currentShowBounds)

			return bounds
		else
			--currentShowBounds = showBounds(self.element.contentBounds, currentShowBounds)

			return self.element.contentBounds
		end
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
	if self.sound then
		audio.play(self.sound)
	end
end

function Item:onFall(game)
	if self.fall then
		self.fall()
	end
end
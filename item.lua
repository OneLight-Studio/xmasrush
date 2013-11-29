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
TYPE_X2_BONUS = 'x2'
TYPE_X2_PRESENT = 'x2_present'

PRESENT_IMG = "img/game_present_#index#.png"
PRESENT_X2_IMG = "img/game_present_#index#_x2.png"
PRESENT_IMG_INDEX_MIN = 1
PRESENT_IMG_INDEX_MAX = 8
PRESENT_WIDTH = 40
PRESENT_HEIGHT = 43
PRESENT_MIN_SPEED = 2
PRESENT_MAX_SPEED = 4
PRESENT_SOUND = audio.loadSound("sound/blop.mp3")

BOMB_IMG = "img/game_bomb.png"
BOMB_WIDTH = 40
BOMB_HEIGHT = 43
BOMB_MIN_SPEED = 3
BOMB_MAX_SPEED = 3
BOMB_SOUND = audio.loadSound("sound/bomb.mp3")

LIFE_BONUS_IMG = "img/game_life.png"
LIFE_BONUS_WIDTH = 40
LIFE_BONUS_HEIGHT = 32
LIFE_BONUS_MIN_SPEED = 6
LIFE_BONUS_MAX_SPEED = 6
LIFE_BONUS_SOUND = audio.loadSound("sound/life_up.mp3")

STAR_BONUS_IMG = "img/game_star.png"
STAR_BONUS_WIDTH = 40
STAR_BONUS_HEIGHT = 40
STAR_BONUS_MIN_SPEED = 7
STAR_BONUS_MAX_SPEED = 7
STAR_BONUS_PRESENT_MIN_SPEED = 7
STAR_BONUS_PRESENT_MAX_SPEED = 7

IMP_WIDTH = 120
IMP_HEIGHT = 150
IMP_LEFT_IMG = "img/game_imp_left.png"
IMP_RIGHT_IMG = "img/game_imp_right.png"
IMP_MIN_SPEED = 0
IMP_MAX_SPEED = 0
IMP_BONUS_WIDTH = 57
IMP_BONUS_HEIGHT = 48
IMP_BONUS_IMG = "img/game_imp_bonus.png"
IMP_BONUS_MIN_SPEED = 7
IMP_BONUS_MAX_SPEED = 7
IMP_SOUND = audio.loadSound("sound/bonus.mp3")

ASPIRATOR_BONUS_WIDTH = 40
ASPIRATOR_BONUS_HEIGHT = 42
ASPIRATOR_BONUS_IMG = "img/game_aspirator_bonus.png"
ASPIRATOR_BONUS_MIN_SPEED = 7
ASPIRATOR_BONUS_MAX_SPEED = 7
ASPIRATOR_ASPIRATION_DELAY = 150
ASPIRATOR_SOUND = audio.loadSound("sound/bonus.mp3")

X2_BONUS_IMG = "img/game_x2_bonus.png"
X2_BONUS_WIDTH = 32
X2_BONUS_HEIGHT = 32
X2_BONUS_MIN_SPEED = 7
X2_BONUS_MAX_SPEED = 7
X2_SOUND = audio.loadSound("sound/bonus.mp3")

-- variables

local currentShowBounds

-- functions

-- core

Item = class(function(this, type, hit, fall, speedMin, speedMax)
	this.type = type

	if type == TYPE_PRESENT then
		this.img = string.gsub(PRESENT_IMG, '#index#', math.random(PRESENT_IMG_INDEX_MIN, PRESENT_IMG_INDEX_MAX))
		this.width = PRESENT_WIDTH
		this.height = PRESENT_HEIGHT
		this.speed = math.random(speedMin, speedMax)
		this.sound = PRESENT_SOUND
	elseif type == TYPE_STAR_PRESENT then
		this.img = string.gsub(PRESENT_IMG, '#index#', math.random(PRESENT_IMG_INDEX_MIN, PRESENT_IMG_INDEX_MAX))
		this.width = PRESENT_WIDTH
		this.height = PRESENT_HEIGHT
		this.speed = math.random(STAR_BONUS_PRESENT_MIN_SPEED, STAR_BONUS_PRESENT_MAX_SPEED)
	elseif type == TYPE_X2_PRESENT then
		this.img = string.gsub(PRESENT_X2_IMG, '#index#', math.random(PRESENT_IMG_INDEX_MIN, PRESENT_IMG_INDEX_MAX))
		this.width = PRESENT_WIDTH
		this.height = PRESENT_HEIGHT
		this.speed = math.random(PRESENT_MIN_SPEED, PRESENT_MAX_SPEED)
		this.sound = PRESENT_SOUND
	elseif type == TYPE_BOMB then
		this.img = BOMB_IMG
		this.width = BOMB_WIDTH
		this.height = BOMB_HEIGHT
		this.speed = math.random(BOMB_MIN_SPEED, BOMB_MAX_SPEED)
		this.sound = BOMB_SOUND
	elseif type == TYPE_IMP then
		this.img = IMP_LEFT_IMG
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
		this.sound = IMP_SOUND
	elseif type == TYPE_ASPIRATOR_BONUS then
		this.img = ASPIRATOR_BONUS_IMG
		this.width = ASPIRATOR_BONUS_WIDTH
		this.height = ASPIRATOR_BONUS_HEIGHT
		this.speed = math.random(ASPIRATOR_BONUS_MIN_SPEED, ASPIRATOR_BONUS_MAX_SPEED)
		this.sound = ASPIRATOR_SOUND
	elseif type == TYPE_X2_BONUS then
		this.img = X2_BONUS_IMG
		this.width = X2_BONUS_WIDTH
		this.height = X2_BONUS_HEIGHT
		this.speed = math.random(X2_BONUS_MIN_SPEED, X2_BONUS_MAX_SPEED)
		this.sound = X2_SOUND
	end

	this.hit = hit
	this.fall = fall
	this.aspirated = nil
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

function Item:elem()
	return self.element
end

function Item:toFront()
	if self.element then
		self.element:toFront()
	end
end

function Item:contentBounds()
	if self.element ~= nil then
		if self.img == IMP_LEFT_IMG or self.img == IMP_RIGHT_IMG then
			local currentBounds = self.element.contentBounds
			currentBounds.xMin = currentBounds.xMin
			currentBounds.xMax = currentBounds.xMax - 10
			currentBounds.yMin = currentBounds.yMin + 70
			currentBounds.yMax = currentBounds.yMax

			--currentShowBounds = showBounds(currentBounds, currentShowBounds)

			self.element:toFront()

			return currentBounds
		else
			local currentBounds = self.element.contentBounds
			currentBounds.xMin = currentBounds.xMin + 10
			currentBounds.xMax = currentBounds.xMax - 10
			currentBounds.yMin = currentBounds.yMin + 10
			currentBounds.yMax = currentBounds.yMax - 10

			--currentShowBounds = showBounds(currentBounds, currentShowBounds)

			return currentBounds
		end
	end
	
	return nil
end

function Item:startTranslate()
	if self.element ~= nil then
		self.element:translate(0, self.speed)
	end
end

function Item:aspiratedTo(toX, toY)
	if self.element ~= nil then
		self.aspirated = system.getTimer()
		transition.to( self.element, {time=ASPIRATOR_ASPIRATION_DELAY, x=toX, y=toY})
	end
end

function Item:aspiratedDone()
	if self.aspirated ~= nil then
		local currTime = system.getTimer()
		return (currTime - self.aspirated) >= ASPIRATOR_ASPIRATION_DELAY
	end

	return false
end

function Item:remove()
	self:onExitScene()
end

function Item:impToLeft(gotToLeft)
	if gotToLeft == true then
		self.img = IMP_LEFT_IMG
	else
		self.img = IMP_RIGHT_IMG
	end
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

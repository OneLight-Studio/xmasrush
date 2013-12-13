-- Game

package.loaded["src.arcade.game"] = nil
require 'src.util.class'

-- constants

local SCORE_WIDTH = 130
local LIVES_WIDTH = 100
local FONT_SIZE = 20
local TXT_HEIGHT = 40
local TXT_SCALE_RATIO_POSITIVE = 2
local TXT_SCALE_RATIO_NEGATIVE = 3
local TXT_SCALE_TIME_POSITIVE = 100
local TXT_SCALE_TIME_NEGATIVE = 200

-- variables

-- functions

-- core

Game = class(function(this, level, lives)
	this.initLevel = level
	this.initLives = lives
	this.level = level
	this.lives = lives
end)

function Game:onEnterScene()
	self.level = self.initLevel
	self.lives = self.initLives
	self.score = LEVELS[self.level - 1] or 0
	self.nextLevelScore = LEVELS[self.level]

	self.livesImage = display.newImage( "img/game_menu_life.png" )
	self.livesImage.x = display.contentCenterX - self.livesImage.width / 2
	self.livesImage.y = TXT_HEIGHT / 2

	self.scoreImage = display.newImage( "img/game_menu_score.png" )
	self.scoreImage.x = display.contentWidth - self.scoreImage.width / 2  - SCORE_WIDTH
	self.scoreImage.y = TXT_HEIGHT / 2

	self:updateScore(true)
	self:updateLives(true)
	self:updateLevel()
end

function Game:onExitScene()
	self.score = nil
	self.lives = nil

	display.remove(self.scoreLabel)
	self.scoreLabel = nil
	display.remove(self.livesLabel)
	self.livesLabel = nil
	display.remove(self.livesImage)
	self.livesImage = nil
	display.remove(self.scoreImage)
	self.scoreImage = nil
	display.remove(self.levelText)
	self.levelText = nil
end

function Game:updateScore(positive)
	if self.scoreLabel ~= nil then
		display.remove(self.scoreLabel)
		self.scoreLabel = nil
	end
	self.scoreLabel = display.newText(self.score .. "/" .. (self.nextLevelScore or self.score), display.contentWidth - SCORE_WIDTH, 0, FONT, FONT_SIZE)
	self.scoreLabel.y = TXT_HEIGHT / 2
	-- animate the label
	local scale = TXT_SCALE_RATIO_POSITIVE
	local time = TXT_SCALE_TIME_POSITIVE
	if not positive then
		self.scoreLabel:setTextColor(255, 0, 0)
		scale = TXT_SCALE_RATIO_NEGATIVE
		time = TXT_SCALE_TIME_NEGATIVE
	end
	transition.to(self.scoreLabel, {
		xScale=scale, yScale=scale, time=time, onComplete=function(event)
			transition.to(self.scoreLabel, {
				xScale=1, yScale=1, time=time, onComplete=function(event)
					self.scoreLabel:setTextColor(255, 255, 255)
				end
			})
		end
	})
end

function Game:updateLives(positive)
	if self.livesLabel ~= nil then
		display.remove(self.livesLabel)
		self.livesLabel = nil
	end
	self.livesLabel = display.newText(self.lives, display.contentCenterX, 0, FONT, FONT_SIZE)
	self.livesLabel.y = TXT_HEIGHT / 2
	-- animate the label
	local scale = TXT_SCALE_RATIO_POSITIVE
	local time = TXT_SCALE_TIME_POSITIVE
	if not positive then
		self.livesLabel:setTextColor(255, 0, 0)
		scale = TXT_SCALE_RATIO_NEGATIVE
		time = TXT_SCALE_TIME_NEGATIVE
	end
	transition.to(self.livesLabel, {
		xScale=scale, yScale=scale, time=time, onComplete=function(event)
			transition.to(self.livesLabel, {
				xScale=1, yScale=1, time=time, onComplete=function(event)
					self.livesLabel:setTextColor(255, 255, 255)
				end
			})
		end
	})
end

function Game:updateLevel()
	self.newLevel = true
	self.levelText = display.newText(language:getString("level") .. " " .. self.level, 0, 0, FONT, 50)
	self.levelText.x = display.contentCenterX
	self.levelText.y = display.contentCenterY - 50
	self.levelText.alpha = 0
	transition.to(self.levelText, {
		alpha = 1, time = 500, onComplete = function()
			transition.to(self.levelText, {
				alpha = 0, time = 2000, onComplete = function()
					display.remove(self.levelText)
					self.levelText = nil
				end
			})
		end
	})
end

function Game:scoreLivesToFront()
	if self.scoreImage ~= nil then
		self.scoreImage:toFront()
	end
	if self.scoreLabel ~= nil then
		self.scoreLabel:toFront()
	end

	if self.livesImage ~= nil then
		self.livesImage:toFront()
	end
	if self.livesLabel ~= nil then
		self.livesLabel:toFront()
	end
end

function Game:increaseScore(number)
	self.score = self.score + number
	self:updateScore(number >= 0)
	if self.nextLevelScore and self.score >= self.nextLevelScore then
		if self.level < #LEVELS then
			-- level up
			self.level = self.level + 1
			self.nextLevelScore = LEVELS[self.level]
			if self.level > gameSettings.level then
				gameSettings.level = self.level
				loadsave.saveTable(gameSettings, GAME_SETTINGS)
			end
			self:updateLevel()
			if gameSettings.soundEffectEnable then
				audio.play(audio.loadSound("sound/levelup.mp3"))
			end
		end
	end
end

function Game:decreaseScore(number)
	self.score = self.score - number
	self:updateScore(number <= 0)
end

function Game:increaseLives(number)
	self.lives = self.lives + number
	self:updateLives(number >= 0)
end

function Game:decreaseLives(number)
	self.lives = math.max(0, self.lives - number)
	self:updateLives(number <= 0)
end

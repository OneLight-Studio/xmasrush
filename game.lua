-- Game

require 'class'

-- constants

local SCORE_WIDTH = 60
local LIVES_WIDTH = 120


-- variables

-- functions

-- core

Game = class(function(this, score, lives)
	this.initScore = score
	this.initLives = lives
	this.score = score
	this.lives = lives
end)

function Game:onEnterScene()
	self.score = self.initScore
	self.lives = self.initLives

	self.livesImage = display.newImage( "img/game_menu_life.png" )
	self.livesImage.x = display.contentWidth - self.livesImage.width / 2 - LIVES_WIDTH
	self.livesImage.y = self.livesImage.height / 2

	self.scoreImage = display.newImage( "img/game_menu_score.png" )
	self.scoreImage.x = display.contentWidth - self.scoreImage.width / 2  - SCORE_WIDTH
	self.scoreImage.y = self.scoreImage.height / 2

	self:updateScore()
	self:updateLives()
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
end

function Game:updateScore()
	if self.scoreLabel ~= nil then
		display.remove(self.scoreLabel)
	end
	self.scoreLabel = display.newText(self.score, display.contentWidth - SCORE_WIDTH, 2, native.systemFont, 20)
end

function Game:updateLives()
	if self.livesLabel ~= nil then
		display.remove(self.livesLabel)
	end
	self.livesLabel = display.newText(self.lives, display.contentWidth - LIVES_WIDTH, 2, native.systemFont, 20)
end

function Game:scoreLivesToFront()
	if self.scoreLabel ~= nil then
		self.scoreLabel:toFront()
	end

	if self.livesLabel ~= nil then
		self.livesLabel:toFront()
	end
end

function Game:increaseScore(number)
	self.score = self.score + number
	self:updateScore()
end

function Game:decreaseScore(number)
	self.score = self.score - number
	self:updateScore()
end

function Game:increaseLives(number)
	self.lives = self.lives + number
	self:updateLives()
end

function Game:decreaseLives(number)
	self.lives = self.lives - number
	self:updateLives()
end
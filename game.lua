-- Game

require 'class'

-- constants

local SCORE_TEXT = ""
local SCORE_WIDTH = 60
local LIVES_TEXT = ""
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

	local livesImage = display.newImage( "img/game_menu_life.png" )
	livesImage.x = display.contentWidth - livesImage.width / 2 - LIVES_WIDTH
	livesImage.y = livesImage.height / 2

	local scoreImage = display.newImage( "img/game_menu_score.png" )
	scoreImage.x = display.contentWidth - scoreImage.width / 2  - SCORE_WIDTH
	scoreImage.y = scoreImage.height / 2


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
end

function Game:updateScore()
	if self.scoreLabel ~= nil then
		display.remove(self.scoreLabel)
	end
	self.scoreLabel = display.newText(SCORE_TEXT .. self.score, display.contentWidth - SCORE_WIDTH, 2, native.systemFont, 20)
end

function Game:updateLives()
	if self.livesLabel ~= nil then
		display.remove(self.livesLabel)
	end
	self.livesLabel = display.newText(LIVES_TEXT .. self.lives, display.contentWidth - LIVES_WIDTH, 2, native.systemFont, 20)
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
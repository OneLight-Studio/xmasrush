require 'class'

local SCORE_TEXT = "Score "
local SCORE_WIDTH = 80
local LIVES_TEXT = "Vies "
local LIVES_WIDTH = 40

Game = class(function(this, score, lives)
	this.score = score
	this.lives = lives;
end)

function Game:updateScore()
	display.remove(self.scoreLabel)
	self.scoreLabel = display.newText(SCORE_TEXT .. self.score, display.contentWidth - SCORE_WIDTH, 0)
end

function Game:updateLives()
	display.remove(self.livesLabel)
	self.livesLabel = display.newText(LIVES_TEXT .. self.lives, display.contentCenterX - LIVES_WIDTH / 2, 0)
end

function Game:scoreLivesToFront()
	if self.scoreLabel then
		self.scoreLabel:toFront()
	end

	if self.livesLabel then
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
-- Game

require 'class'

-- constants

local SCORE_WIDTH = 80
local LIVES_WIDTH = 150
local FONT_SIZE = 30
local TXT_HEIGHT = 40
local TXT_SCALE_RATIO_POSITIVE = 2
local TXT_SCALE_RATIO_NEGATIVE = 3
local TXT_SCALE_TIME_POSITIVE = 100
local TXT_SCALE_TIME_NEGATIVE = 200

-- variables

-- functions

-- core

Game = class(function(this, score, lives)
	this.initScore = score
	this.initLives = lives
	this.score = score
	this.lives = lives
	this.highscore = 0
end)

function Game:onEnterScene()
	self.score = self.initScore
	self.lives = self.initLives

	self.livesImage = display.newImage( "img/game_menu_life.png" )
	self.livesImage.x = display.contentWidth - self.livesImage.width / 2 - LIVES_WIDTH
	self.livesImage.y = TXT_HEIGHT / 2

	self.scoreImage = display.newImage( "img/game_menu_score.png" )
	self.scoreImage.x = display.contentWidth - self.scoreImage.width / 2  - SCORE_WIDTH
	self.scoreImage.y = TXT_HEIGHT / 2

	self:updateScore(true)
	self:updateLives(true)

	if gameSettings.highscores then
		self.highscore = gameSettings.highscores[1]
	end
	self.newHighscore = false
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

function Game:updateScore(positive)
	if self.scoreLabel ~= nil then
		display.remove(self.scoreLabel)
	end
	self.scoreLabel = display.newText(self.score, display.contentWidth - SCORE_WIDTH, 0, FONT, FONT_SIZE)
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

	if self.score > self.highscore and not self.newHighscore then
		local highscoreText = display.newText(language:getString("highscore"), 0, 0, FONT, 60)
		highscoreText.x = display.contentCenterX
		highscoreText.y = display.contentCenterY
		timer.performWithDelay(100, function()
			highscoreText.alpha = highscoreText.alpha < 1 and 1 or 0
		end, 6)
		timer.performWithDelay(1000, function()
			display.remove(highscoreText)
		end)
		self.newHighscore = true
	end
end

function Game:updateLives(positive)
	if self.livesLabel ~= nil then
		display.remove(self.livesLabel)
	end
	self.livesLabel = display.newText(self.lives, display.contentWidth - LIVES_WIDTH, 0, FONT, FONT_SIZE)
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

function Game:gameOver()
	if not gameSettings.highscores then
		gameSettings.highscores = {	self.score }
		loadsave.saveTable(gameSettings, GAME_SETTINGS)
	else
		local done = false
		for i,s in ipairs(gameSettings.highscores) do
			if s and self.score > s then
				table.insert(gameSettings.highscores, i, self.score)
				loadsave.saveTable(gameSettings, GAME_SETTINGS)
				done = true
				break
			end
		end
		if not done and table.getn(gameSettings.highscores) < 10 then
			table.insert(gameSettings.highscores, self.score)
			loadsave.saveTable(gameSettings, GAME_SETTINGS)
		end
	end
	while table.getn(gameSettings.highscores) > 10 do
		table.remove(gameSettings.highscores, 11)
	end
end

-- Game

require 'class'

-- constants

local SCORE_WIDTH = 150
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

	self.highscore = 0
	if gameSettings.highscores then
		self.highscore = gameSettings.highscores[1]
	end
	self.newHighscore = false

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
end

function Game:updateScore(positive)
	if self.scoreLabel ~= nil then
		display.remove(self.scoreLabel)
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

	if self.highscore > 0 and self.score > self.highscore and not self.newHighscore then
		--[[
		local highscoreText = display.newText(language:getString("highscore"), 0, 0, FONT, 50)
		highscoreText.x = display.contentCenterX
		highscoreText.y = display.contentCenterY
		timer.performWithDelay(100, function()
			highscoreText.alpha = highscoreText.alpha < 1 and 1 or 0
		end, 6)
		timer.performWithDelay(1000, function()
			display.remove(highscoreText)
		end)
		--]]
		self.newHighscore = true
	end
end

function Game:updateLives(positive)
	if self.livesLabel ~= nil then
		display.remove(self.livesLabel)
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
	local levelText = display.newText(language:getString("level") .. " " .. self.level, 0, 0, FONT, 50)
	levelText.x = display.contentCenterX
	levelText.y = display.contentCenterY
	levelText.alpha = 0
	transition.to(levelText, {
		alpha = 1, time = 500, onComplete = function()
			transition.to(levelText, {
				alpha = 0, time = 3000, onComplete = function()
					display.remove(levelText)
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
		if self.level < table.getn(LEVELS) then
			-- level up
			self.level = self.level + 1
			self.nextLevelScore = LEVELS[self.level]
			if self.level > gameSettings.level then
				gameSettings.level = self.level
				loadsave.saveTable(gameSettings, GAME_SETTINGS)
			end
			self:updateLevel()
			audio.play(audio.loadSound("sound/levelup.mp3"))
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
	while table.getn(gameSettings.highscores) > MAX_HIGHSCORES do
		table.remove(gameSettings.highscores, MAX_HIGHSCORES + 1)
	end
end

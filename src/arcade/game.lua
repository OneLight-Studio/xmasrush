-- Game

require 'src.util.class'

-- constants

local SCORE_WIDTH = 60
local FONT_SIZE = 20
local TXT_HEIGHT = 40
local TXT_SCALE_RATIO_POSITIVE = 2
local TXT_SCALE_RATIO_NEGATIVE = 3
local TXT_SCALE_TIME_POSITIVE = 100
local TXT_SCALE_TIME_NEGATIVE = 200

-- variables

-- functions

-- core

Game = class(function(this)
end)

function Game:onEnterScene()
	self.score = 0

	self.scoreImage = display.newImage( "img/game_menu_score.png" )
	self.scoreImage.x = display.contentWidth - self.scoreImage.width / 2  - SCORE_WIDTH
	self.scoreImage.y = TXT_HEIGHT / 2

	self.highscore = 0
	if gameSettings.highscores then
		self.highscore = gameSettings.highscores[1]
	end
	self.newHighscore = false

	self:updateScore(true)
end

function Game:onExitScene()
	self.score = nil

	display.remove(self.scoreLabel)
	self.scoreLabel = nil
	display.remove(self.scoreImage)
	self.scoreImage = nil
	display.remove(self.chronoLabel)
	self.chronoLabel = nil
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

	if self.highscore > 0 and self.score > self.highscore and not self.newHighscore then
		local highscoreText = display.newText(language:getString("highscore"), 0, 0, FONT, 50)
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

function Game:updateChrono(seconds)
	if self.chronoLabel then
		display.remove(self.chronoLabel)
	end
	self.chronoLabel = display.newText(string.format("%d:%02d", math.floor(seconds / 60), seconds % 60), 0, 0, FONT, FONT_SIZE)
	self.chronoLabel.x = display.contentCenterX
	self.chronoLabel.y = TXT_HEIGHT / 2
	if seconds <= 3 then
		self.chronoLabel:setTextColor(255, 0, 0)
		transition.to(self.chronoLabel, {
			xScale=5, yScale=5, time=200, onComplete=function(event)
				transition.to(self.chronoLabel, {
					xScale=1, yScale=1, time=200
				})
			end
		})
	end
end

function Game:textToFront()
	if self.scoreImage then
		self.scoreImage:toFront()
	end
	if self.scoreLabel then
		self.scoreLabel:toFront()
	end
	if self.chronoLabel then
		self.chronoLabel:toFront()
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
		if not done and table.getn(gameSettings.highscores) < MAX_HIGHSCORES then
			table.insert(gameSettings.highscores, self.score)
			loadsave.saveTable(gameSettings, GAME_SETTINGS)
		end
	end
	while table.getn(gameSettings.highscores) > MAX_HIGHSCORES do
		table.remove(gameSettings.highscores, MAX_HIGHSCORES + 1)
	end
end

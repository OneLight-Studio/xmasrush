-- GameArcade

package.loaded["src.standard.game"] = nil
require 'src.util.class'

-- constants

local SCORE_WIDTH = 60
local FONT_SIZE = 20
local TXT_HEIGHT = 40

local PRESENTS_COMBO = 50

-- variables

-- functions

-- core

GameArcade = class(function(this)
end)

function GameArcade:onEnterScene()
	self.score = 0
	self.combo = 1
	self.consecutivePresents = 0
	self.previousCombo = 0

	self.scoreImage = display.newImage( "img/game_menu_score.png" )
	self.scoreImage.x = display.contentWidth - self.scoreImage.width / 2  - SCORE_WIDTH
	self.scoreImage.y = TXT_HEIGHT / 2

	self.highscore = 0
	if gameSettings.highscores[1] then
		self.highscore = gameSettings.highscores[1]
	end

	self.newHighscore = self.highscore == 0

	self:updateScore(0)
end

function GameArcade:onExitScene()
	self.score = nil

	display.remove(self.scoreLabel)
	self.scoreLabel = nil
	display.remove(self.scoreImage)
	self.scoreImage = nil
	display.remove(self.chronoLabel)
	self.chronoLabel = nil
	display.remove(self.comboLabel)
	self.comboLabel = nil
end

function GameArcade:updateScore(number)
	if self.scoreLabel ~= nil then
		display.remove(self.scoreLabel)
		display.scoreLabel = nil
	end
	self.scoreLabel = display.newText(self.score, display.contentWidth - SCORE_WIDTH, 0, FONT, FONT_SIZE)
	self.scoreLabel.y = TXT_HEIGHT / 2
	-- animate the label
	transition.to(self.scoreLabel, {
		xScale=2, yScale=2, time=100, onComplete=function(event)
			transition.to(self.scoreLabel, {
				xScale=1, yScale=1, time=100
			})
		end
	})
	-- highscore
	if self.highscore > 0 and self.score > self.highscore and not self.newHighscore then
		local highscoreText = display.newText(language:getString("highscore"), 0, 0, FONT, 50)
		highscoreText.x = display.contentCenterX
		highscoreText.y = display.contentCenterY
		timer.performWithDelay(100, function()
			highscoreText.alpha = highscoreText.alpha < 1 and 1 or 0
		end, 6)
		timer.performWithDelay(1000, function()
			display.remove(highscoreText)
			highscoreText = nil
		end)
		self.newHighscore = true
	end
end

function GameArcade:updateChrono(seconds, addTime)
	if self.chronoLabel then
		display.remove(self.chronoLabel)
		self.chronoLabel = nil
	end
	self.chronoLabel = display.newText(string.format("%d:%02d", math.floor(seconds / 60), seconds % 60), 0, 0, FONT, FONT_SIZE)
	-- + 14 to adapte with the background
	self.chronoLabel.x = display.contentCenterX + 14
	self.chronoLabel.y = TXT_HEIGHT / 2

	if addTime then
		self.chronoLabel:setTextColor(0, 255, 0)
			transition.to(self.chronoLabel, {
				xScale=5, yScale=5, time=200, onComplete=function(event)
					transition.to(self.chronoLabel, {
						xScale=1, yScale=1, time=200
					})
				end
			})
	else	
		if seconds <= 3 then
			self.chronoLabel:setTextColor(255, 0, 0)
			transition.to(self.chronoLabel, {
				xScale=5, yScale=5, time=200, onComplete=function(event)
					transition.to(self.chronoLabel, {
						xScale=1, yScale=1, time=200
					})
				end
			})
		else
			self.chronoLabel:setTextColor(128, 128, 128)
		end
	end
end

function GameArcade:textToFront()
	if self.scoreImage then
		self.scoreImage:toFront()
	end
	if self.scoreLabel then
		self.scoreLabel:toFront()
	end
	if self.chronoLabel then
		self.chronoLabel:toFront()
	end
	if self.comboLabel then
		self.comboLabel:toFront()
	end
end

function GameArcade:increaseScore(number)
	self.consecutivePresents = self.consecutivePresents + 1
	self:updateCombo()
	self.score = self.score + ( number * self.combo )
	self:updateScore(number)
end


function GameArcade:clearCombo()
	self.combo = 0
	self.consecutivePresents = 0
	self:updateCombo()
end

function GameArcade:updateCombo()
	
	local increaseCombo = math.floor(self.consecutivePresents / PRESENTS_COMBO)

	if self.consecutivePresents == 0 and self.previousCombo == 0 then
		self.combo = 1
	end

	if self.previousCombo ~= increaseCombo then
		
		self.combo = self.combo + 1

		self.previousCombo = increaseCombo 

		if increaseCombo <= 0 then
			if self.comboLabel then
				self.comboLabel:setTextColor(255, 0, 0)
				transition.to(self.comboLabel, {
					xScale=5, yScale=5, time=200, onComplete=function(event)
						transition.to(self.comboLabel, {
							xScale=1, yScale=1, alpha=0, time=200, onComplete=function()
								display.remove(self.comboLabel)
								self.comboLabel = nil
							end
						})
					end
				})
			end
		else
			if self.comboLabel ~= nil then
				display.remove(self.comboLabel)
				self.comboLabel = nil
			end
			if self.combo  > 1 then
				self.comboLabel = display.newText("x" .. self.combo , 0, 0, FONT, FONT_SIZE)
				self.comboLabel.x = display.contentCenterX
				self.comboLabel.y = display.contentCenterY
				self.comboLabel.alpha = 0
				self.comboLabel:setTextColor(170, 170, 255)
				transition.to(self.comboLabel, {
					xScale=10, yScale=10, alpha=1, time=200, onComplete=function()
						transition.to(self.comboLabel, {
							xScale=1, yScale=1, x=self.scoreLabel.x, y=TXT_HEIGHT, time=200, onComplete=function(event)
								transition.to(self.comboLabel, {
									xScale=1, yScale=1, time=200
								})
							end
						})
					end
				})
			end
		end
	end

end

function GameArcade:gameOver()
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
		if not done and #gameSettings.highscores < MAX_HIGHSCORES then
			table.insert(gameSettings.highscores, self.score)
			loadsave.saveTable(gameSettings, GAME_SETTINGS)
		end
	end
	while #gameSettings.highscores > MAX_HIGHSCORES do
		table.remove(gameSettings.highscores, MAX_HIGHSCORES + 1)
	end
end

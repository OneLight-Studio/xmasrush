-- Scene Game Over
require "src.common.item"

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local gameOverText
local scoreText
local scoreImg
local highscoreText
local retryBtn
local quitBtn
local fbBtn
local btnSmall = {}

local BTN_COUNT = 2
local BTN_SMALL_COUNT = 3

local function addButton(position, title, onTap)
	local btn = widget.newButton({
		defaultFile = BTN_IMG,
		overFile = BTN_IMG_PRESSED,
		label = title,
		labelColor = { default = BTN_LABEL_COLOR },
		font = FONT,
		fontSize = BTN_FONT_SIZE,
		onRelease = onTap
	})
	btn.x = display.contentCenterX
	btn.y = display.contentHeight - BTN_GAP - BTN_SIZE / 2 - (BTN_COUNT - position) * (BTN_SIZE + BTN_GAP)
	return btn
end

local function addButtonSmall(position, img, img_pressed, onTap)
	local btn = widget.newButton({
		defaultFile = img,
		overFile = img_pressed,
		onRelease = onTap
	})
	btn.x = display.contentWidth - BTN_GAP - BTN_SIZE / 2
	btn.y = display.contentHeight - BTN_GAP - BTN_SIZE / 2 - (BTN_SMALL_COUNT - position) * (BTN_SIZE + BTN_GAP) 
	btnSmall[position] = btn
	return btn
end

-- scene functions

function scene:createScene( event )
    -- Nothing
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	if gameSettings.soundEffectEnable then
		audio.play(audio.loadSound("sound/game_over.mp3"))
	end

	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 180)

	gameOverText = display.newText(language:getString("game.over.arcade"), 0, 0, FONT, 60)
	gameOverText.x = display.contentCenterX
	gameOverText.y = display.contentCenterY - 120

	scoreImg = display.newImageRect("img/game_present_4.png", PRESENT_WIDTH, PRESENT_HEIGHT)
	scoreImg.x = display.contentCenterX - 50
	scoreImg.y = display.contentCenterY - 48

	local game = event.params.game
	scoreText = display.newText(game.score, 0, 0, FONT, 30)
	scoreText.x = display.contentCenterX + 30
	scoreText.y = display.contentCenterY - 40

	if game.newHighscore then
		timer.performWithDelay(350, function()
			highscoreText = display.newText(language:getString("highscore"), 0, 0, 200, 150, FONT, 30)
			highscoreText.x = display.contentCenterX - 100
			highscoreText.y = display.contentCenterY - 20
			highscoreText.align = "center"
			highscoreText:rotate(-35)
			transition.from(highscoreText, { xScale = 5, yScale = 5, time = 100, onComplete = function()
				if gameSettings.soundEffectEnable then
					audio.play(audio.loadSound("sound/highscore.mp3"))
				end
			end})
		end)
	end

	retryBtn = addButton(1, language:getString("menu.retry"), function()
		game.restart = true
		storyboard.hideOverlay()
	end)
	quitBtn = addButton(2, language:getString("menu.quit"), function() 
		game.quit = true
		moveToScene("scene_home") 
	end)

	local url = url_encode(language:getString("share.url"))
	local title = url_encode(language:getString("game.name"))
	local summary = url_encode(language:getString("share.highscore.1") .. game.score .. language:getString("share.highscore.2"))
	addButtonSmall(1, "img/btn_fb.png", "img/btn_fb_pressed.png", function()
		system.openURL("http://www.facebook.com/sharer/sharer.php?m2w&s=100&p[url]=" .. url .. "&p[title]=" .. title .. "&p[summary]=" .. summary)
	end)
	addButtonSmall(2, "img/btn_googleplus.png", "img/btn_googleplus_pressed.png", function()
		system.openURL("https://plus.google.com/share?url=" .. url)
	end)
	addButtonSmall(3, "img/btn_twitter.png", "img/btn_twitter_pressed.png", function()
		local hashtags = url_encode(string.gsub(language:getString("game.name"), "%s+", ""))
		local via = url_encode(language:getString("share.twitter"))
		system.openURL("https://twitter.com/intent/tweet?url=" .. url .. "&text=" .. summary .. "&related=" .. via .. "&hashtags=" .. hashtags .. "&via=" .. via)
	end)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(gameOverText)
	display.remove(scoreImg)
	display.remove(scoreText)
	display.remove(highscoreText)
	display.remove(retryBtn)
	display.remove(quitBtn)
	bg = nil
	gameOverText = nil
	scoreImg = nil
	scoreText = nil
	highscoreText = nil
	retryBtn = nil
	quitBtn = nil

	for i,btn in ipairs(btnSmall) do
		display.remove(btn)
		btn = nil
	end
end

function scene:destroyScene( event )
	-- Nothing
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene

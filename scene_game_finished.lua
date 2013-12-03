-- Scene Game Finished

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local text
local img
local quitBtn
local btnSmall = {}
local nbBtn = 0

local BTN_Y_MIN = 250
local BTN_SMALL_COUNT = 3

local function addButton(title, onTap)
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
	btn.y = BTN_Y_MIN + nbBtn * (BTN_SIZE + BTN_GAP)
	nbBtn = nbBtn + 1
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
	storyboard.isOverlay = true

	if gameSettings.soundEffectEnable then
		audio.play(audio.loadSound("sound/game_finished.mp3"))
	end

	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 180)

	text = display.newText(language:getString("game.finished"), 0, 0, FONT, 60)
	text.x = display.contentCenterX
	text.y = display.contentCenterY - 100

	img = display.newImage("img/game_paddle_gold.png", PADDLE_WIDTH, PADDLE_HEIGHT)
	img.x = display.contentCenterX
	img.y = display.contentCenterY

	local game = event.params.game
	quitBtn = addButton(language:getString("menu.quit"), function() 
		game.quit = true
		moveToScene("scene_home") 
	end)

	local url = language:getString("share.url")
	local title = language:getString("game.name")
	local summary = language:getString("share.text.finished")
	addButtonSmall(1, "img/btn_fb.png", "img/btn_fb_pressed.png", function()
		system.openURL("http://www.facebook.com/sharer/sharer.php?s=100&p[url]=" .. url .. "&p[title]=" .. title .. "&p[summary]=" .. summary)
	end)
	addButtonSmall(2, "img/btn_googleplus.png", "img/btn_googleplus_pressed.png", function()
		system.openURL("https://plus.google.com/share?url=" .. url)
	end)
	addButtonSmall(3, "img/btn_twitter.png", "img/btn_twitter_pressed.png", function()
		local hashtags = string.gsub(language:getString("game.name"), "%s+", "")
		local via = language:getString("share.twitter")
		system.openURL("https://twitter.com/intent/tweet?url=" .. url .. "&text=" .. summary .. "&related=" .. via .. "&hashtags=" .. hashtags .. "&via=" .. via)
	end)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(text)
	display.remove(img)
	display.remove(quitBtn)
	bg = nil
	text = nil
	img = nil
	quitBtn = nil
	for i,btn in ipairs(btnSmall) do
		display.remove(btn)
		btn = nil
	end

	storyboard.isOverlay = false
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

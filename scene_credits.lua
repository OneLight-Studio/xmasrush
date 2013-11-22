-- Scene Credits

-- variables

local widget = require "widget"
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local cancelButton
local rect
local imageLogo
local textCopyright
local btnWebSite
local btnWebSiteUnderline

-- scene functions

function scene:createScene( event )
	-- Nothing
end

function scene:willEnterScene( event )
	-- Nothing
end

function scene:enterScene( event )
	local group = self.view

    bg = display.newImage( "img/bg.jpg" )

	cancelButton = display.newImageRect("img/close.png", 32, 32)
	cancelButton.x = display.contentWidth - 20
	cancelButton.y = 20
	cancelButton:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

	local startX = 15;
    rect = display.newRoundedRect( 15, 15, display.contentWidth - (startX*2), display.contentHeight - (startX*2), 17 )
	rect:setFillColor(0, 0, 0)
	rect.alpha = 0.6
	rect.strokeWidth = 3
	rect:setStrokeColor(180, 180, 180)

	imageLogo = display.newImageRect("img/credits_logo.png", 133, 133)
	imageLogo.x = display.contentWidth / 2 
	imageLogo.y = imageLogo.contentHeight / 2 + 45

	btnWebSite = display.newText(language:getString("credits.website"), 0, 0, FONT, 28)
	btnWebSite.x = display.contentWidth / 2
	btnWebSite.y = imageLogo.y + imageLogo.contentHeight / 2 + 40

	btnWebSite:addEventListener( "tap", function(event) system.openURL( "http://" .. language:getString("credits.website") ) end)
	btnWebSiteUnderline = display.newLine(btnWebSite.x - (btnWebSite.contentWidth/2), btnWebSite.y + ((btnWebSite.contentHeight/2)-3), btnWebSite.x + (btnWebSite.contentWidth/2), btnWebSite.y + ((btnWebSite.contentHeight/2)-3))
	btnWebSiteUnderline.width = 2

	textCopyright = display.newText(language:getString("credits.copyright"), 0, 0, FONT, 16)
	textCopyright.x = display.contentWidth / 2 
	textCopyright.y = btnWebSiteUnderline.y + btnWebSiteUnderline.contentHeight / 2 + 25

	group:insert(bg)
	group:insert(rect)
	group:insert(cancelButton)
	group:insert(imageLogo)
	group:insert(textCopyright)
	group:insert(btnWebSite)
	group:insert(btnWebSiteUnderline)
end

function scene:exitScene( event )
	display.remove(bg)
	bg = nil
	display.remove(cancelButton)
	cancelButton = nil
	display.remove(rect)
	rect = nil

	--display.remove(imageWiteRect)
	--imageWiteRect = nil
	display.remove(imageLogo)
	imageLogo = nil
	display.remove(textCopyright)
	textCopyright = nil
	display.remove(btnWebSite)
	btnWebSite = nil
	display.remove(btnWebSiteUnderline)
	btnWebSiteUnderline = nil
end

function scene:destroyScene( event )
	-- Nothing
end

-- core

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
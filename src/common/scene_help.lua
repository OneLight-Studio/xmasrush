-- Scene Help

-- variables

local widget = require "widget"
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local bg
local cancelButton
local rect

local textObjectif
local textGitf
local textLife
local textBomb
local textStar
local textImp
local textVacuum
local textSnowflake
local textBig
local textEmpty

local imageGitf
local imageLife
local imageBomb
local imageStar
local imageImp
local imageVacuum
local imageSnowflake
local imageBig

local INIT_Y_FIRST_ELEMENT = 20
local HEIGHT_SPACE_BETWEEN_ELEMENT = 17

-- scene functions

function scene:createScene( event )
   -- Nothing
end

function scene:willEnterScene( event )
   -- Nothing
end

function scene:enterScene( event )
	local startX = 15;
	local startXImage = startX + 25
	local startXText = startX + 50


	local groupView = self.view

    local group = widget.newScrollView
	{
	    top = startXImage + 3,
	    left = startX,
	    width = 445,
	    height = 250,
	    scrollWidth = display.contentWidth - (startX*2),
	    scrollHeight = 770,
	    hideBackground = true,
	    horizontalScrollDisabled = true,
	    maskFile = "img/help_mask.png",
	}

	bg = display.newImage( "img/bg.jpg" )

	cancelButton = display.newImageRect("img/close.png", 32, 32)
	cancelButton.x = display.contentWidth - 20
	cancelButton.y = 20
	cancelButton:addEventListener("tap", function ( event )
		moveToScene('scene_home')
	end)

    rect = display.newRoundedRect( 15, 15, display.contentWidth - (startX*2), display.contentHeight - (startX*2), 17 )
	rect:setFillColor(0, 0, 0)
	rect.alpha = 0.6
	rect.strokeWidth = 3
	rect:setStrokeColor(180, 180, 180)

	textObjectif = display.newText(language:getString("help.objectif"),  startXImage, INIT_Y_FIRST_ELEMENT, display.contentWidth - (startXImage*2), 50, FONT, 16)
	
	textGitf = display.newText(language:getString("help.gitf"), startXText, textObjectif.y + 10 + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textGitf.y = textObjectif.y

	textBomb = display.newText(language:getString("help.bomb"), startXText, textGitf.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textBomb.y = textGitf.y + textGitf.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textX2 = display.newText(language:getString("help.x2"), startXText, textBomb.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textX2.y = textBomb.y + textBomb.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textImp = display.newText(language:getString("help.imp"), startXText, textX2.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textImp.y = textX2.y + textX2.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textVacuum = display.newText(language:getString("help.vacuum"), startXText, textImp.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textVacuum.y = textImp.y + textImp.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textLife = display.newText(language:getString("help.life"), startXText, textVacuum.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textLife.y = textVacuum.y + textVacuum.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textStar = display.newText(language:getString("help.star"), startXText, textLife.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textStar.y = textLife.y + textLife.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textSnowflake = display.newText(language:getString("help.snowflake"), startXText, textStar.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textSnowflake.y = textStar.y + textStar.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textBig = display.newText(language:getString("help.big"), startXText, textSnowflake.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textBig.y = textSnowflake.y + textSnowflake.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textEmpty = display.newText(" ", startXText, textBig.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textEmpty.y = textBig.y + textBig.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	imageGitf = display.newImageRect("img/help_presents.png", 30, 32)
	imageGitf.x = startXImage
	imageGitf.y = textObjectif.y  - (imageGitf.height / 3)

	imageBomb = display.newImageRect("img/game_bomb.png", 28, 32)
	imageBomb.x = startXImage
	imageBomb.y = textGitf.y + textGitf.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageBomb.height / 3)

	imageX2 = display.newImageRect("img/game_x2_bonus.png", 32, 18)
	imageX2.x = startXImage
	imageX2.y = textBomb.y + textBomb.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageX2.height / 3)

	imageImp = display.newImageRect("img/game_imp_bonus.png", 32, 27)
	imageImp.x = startXImage
	imageImp.y = textX2.y + textX2.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageImp.height / 3)

	imageVacuum = display.newImageRect("img/game_aspirator_bonus.png", 29, 32)
	imageVacuum.x = startXImage
	imageVacuum.y = textImp.y + textImp.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageVacuum.height / 3)

	imageLife = display.newImageRect("img/game_life.png", 32, 28)
	imageLife.x = startXImage
	imageLife.y = textVacuum.y + textVacuum.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageLife.height / 4)

	imageStar = display.newImageRect("img/game_star.png", 32, 32)
	imageStar.x = startXImage
	imageStar.y = textLife.y + textLife.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageStar.height / 3)

	imageSnowflake = display.newImageRect("img/game_snowflake_bonus.png", 27, 32)
	imageSnowflake.x = startXImage
	imageSnowflake.y = textStar.y + textStar.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageSnowflake.height / 3)
	
	imageBig = display.newImageRect("img/game_big_bonus.png", 12, 32)
	imageBig.x = startXImage
	imageBig.y = textSnowflake.y + textSnowflake.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageBig.height / 3)

	group:insert(textGitf)
	group:insert(textLife)
	group:insert(textBomb)
	group:insert(textStar)
	group:insert(textImp)
	group:insert(textVacuum)
	group:insert(textX2)
	group:insert(textSnowflake)
	group:insert(textBig)
	group:insert(textEmpty)

	group:insert(imageGitf)
	group:insert(imageLife)
	group:insert(imageBomb)
	group:insert(imageStar)
	group:insert(imageImp)
	group:insert(imageVacuum)
	group:insert(imageX2)
	group:insert(imageSnowflake)
	group:insert(imageBig)

	groupView:insert(bg)
	groupView:insert(rect)
	groupView:insert(cancelButton)
	groupView:insert(textObjectif)
	groupView:insert(group)



end

function scene:exitScene( event )
	display.remove(bg)
	bg = nil
	display.remove(cancelButton)
	cancelButton = nil
	display.remove(rect)
	rect = nil

	display.remove(textObjectif)
	textObjectif = nil
	display.remove(textGitf)
	textGitf = nil
	display.remove(textLife)
	textLife = nil
	display.remove(textBomb)
	textBomb = nil
	display.remove(textStar)
	textStar = nil
	display.remove(textImp)
	textImp = nil
	display.remove(textVacuum)
	textVacuum = nil
	display.remove(textX2)
	textX2 = nil
	display.remove(textSnowflake)
	textSnowflake = nil
	display.remove(textBig)
	textBig = nil
	display.remove(textEmpty)
	textEmpty = nil

	display.remove(imageGitf)
	imageGitf = nil
	display.remove(imageLife)
	imageLife = nil
	display.remove(imageBomb)
	imageBomb = nil
	display.remove(imageStar)
	imageStar = nil
	display.remove(imageImp)
	imageImp = nil
	display.remove(imageVacuum)
	imageVacuum = nil
	display.remove(imageX2)
	imageX2 = nil
	display.remove(imageSnowflake)
	imageSnowflake = nil
	display.remove(imageBig)
	imageBig = nil

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

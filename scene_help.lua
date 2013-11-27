-- Scene Help

-- variables

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
local imageGitf
local imageLife
local imageBomb
local imageStar
local imageImp
local imageVacuum

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

	local startXImage = startX + 25
	local startXText = startX + 50
	
	textObjectif = display.newText(language:getString("help.objectif"),  startXImage, INIT_Y_FIRST_ELEMENT, display.contentWidth - (startXImage*2), 50, FONT, 16)
	
	textGitf = display.newText(language:getString("help.gitf"), startXText, textObjectif.y + 10 + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textGitf.y = textObjectif.y + textObjectif.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT + 10

	textLife = display.newText(language:getString("help.life"), startXText, textGitf.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textLife.y = textGitf.y + textGitf.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textBomb = display.newText(language:getString("help.bomb"), startXText, textLife.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textBomb.y = textLife.y + textLife.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textStar = display.newText(language:getString("help.star"), startXText, textBomb.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textStar.y = textBomb.y + textBomb.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textImp = display.newText(language:getString("help.imp"), startXText, textStar.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textImp.y = textStar.y + textStar.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	textVacuum = display.newText(language:getString("help.vacuum"), startXText, textImp.y + HEIGHT_SPACE_BETWEEN_ELEMENT, display.contentWidth - ((startXImage*2)+5), 40, FONT, 16)
	textVacuum.y = textImp.y + textImp.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT

	imageGitf = display.newImageRect("img/help_presents.png", 32, 32)
	imageGitf.x = startXImage
	imageGitf.y = textObjectif.y + textObjectif.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT + 10 - (imageGitf.height / 3)

	imageLife = display.newImageRect("img/game_life.png", 32, 32)
	imageLife.x = startXImage
	imageLife.y = textGitf.y + textGitf.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageLife.height / 4)

	imageBomb = display.newImageRect("img/game_bomb.png", 32, 32)
	imageBomb.x = startXImage
	imageBomb.y = textLife.y + textLife.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageBomb.height / 3)

	imageStar = display.newImageRect("img/game_star.png", 32, 32)
	imageStar.x = startXImage
	imageStar.y = textBomb.y + textBomb.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageStar.height / 3)

	imageImp = display.newImageRect("img/game_imp_bonus.png", 32, 32)
	imageImp.x = startXImage
	imageImp.y = textStar.y + textStar.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageImp.height / 3)

	imageVacuum = display.newImageRect("img/game_aspirator_bonus.png", 32, 32)
	imageVacuum.x = startXImage
	imageVacuum.y = textImp.y + textImp.contentHeight / 2 + HEIGHT_SPACE_BETWEEN_ELEMENT - (imageVacuum.height / 3)

	group:insert(bg)
	group:insert(rect)
	group:insert(cancelButton)
	group:insert(textObjectif)
	group:insert(textGitf)
	group:insert(textLife)
	group:insert(textBomb)
	group:insert(textStar)
	group:insert(textImp)
	group:insert(textVacuum)
	group:insert(imageGitf)
	group:insert(imageLife)
	group:insert(imageBomb)
	group:insert(imageStar)
	group:insert(imageImp)
	group:insert(imageVacuum)

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

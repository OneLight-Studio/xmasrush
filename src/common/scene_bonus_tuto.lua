-- Scene Game Pause

-- variables

local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()
local bg
local bonusImg
local bonusArrow
local bonusTxt
local resumeBtn

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
	btn.y = display.contentCenterY + 100
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
	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg:setFillColor(0, 0, 0, 100)

	local bonusTxtString
	local bonusType = event.params.bonusType
	local bonusItem = event.params.bonusItem

	if bonusType == TYPE_PRESENT then
		bonusTxtString = "help.gitf"
	elseif bonusType == TYPE_BOMB then
		bonusTxtString = "help.bomb"
	elseif bonusType == TYPE_X2_BONUS then
		bonusTxtString = "help.x2"
	elseif bonusType == TYPE_IMP_BONUS then
		bonusTxtString = "help.imp"
	elseif bonusType == TYPE_ASPIRATOR_BONUS then
		bonusTxtString = "help.vacuum"
	elseif bonusType == TYPE_LIFE_BONUS then
		bonusTxtString = "help.life"
	elseif bonusType == TYPE_STAR_BONUS then
		bonusTxtString = "help.star"
	elseif bonusType == TYPE_SNOWFLAKE_BONUS then
		bonusTxtString = "help.snowflake"
	elseif bonusType == TYPE_BIG_BONUS then
		bonusTxtString = "help.big"
	elseif bonusType == TYPE_HOURGLASS_BONUS then
		bonusTxtString = "help.hourglass"
	end

	bonusImg = display.newImageRect(bonusItem.img, bonusItem.element.width, bonusItem.element.height)
	bonusImg.x = bonusItem.element.x
	bonusImg.y = bonusItem.element.y

	bonusArrow = display.newImageRect("img/arrow_up.png", 64, 64)
	bonusArrow.x = bonusImg.x
	bonusArrow.y = bonusImg.y + bonusImg.height + 30

	bonusTxt = display.newText(language:getString(bonusTxtString), 0, 0, FONT, 24)
	bonusTxt.x = display.contentCenterX
	bonusTxt.y = display.contentCenterY

	resumeBtn = addButton(language:getString("menu.tuto.continue"), function(event) storyboard.hideOverlay() end)
end

function scene:exitScene( event )
	display.remove(bg)
	display.remove(resumeBtn)
	display.remove(bonusImg)
	display.remove(bonusArrow)
	display.remove(bonusTxt)
	bg = nil
	resumeBtn = nil
	bonusImg = nil
	bonusArrow = nil
	bonusTxt = nil
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

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- requires
local widget = require( "widget" )

-- elements init
local bg, info, header, contentBox

-- colors
local transparent = { default={ 1, 1, 1, 0 }, over={ 1, 1, 1, 0 } }

-- dimensions
local margins = 5

-- images
local image = { path="images\\defaultbg.png", width=1080, height=1920, x=0.5, y=0.5 }
local headImage = { path="images\\header.png", width=933, height=553, x=0.5, y=0.2 }
local whiteBG = { path="images\\boxbianco.png", width=1025, height=800, x=0.5, y=0.6 }
local infoBtn = { path="images\\btn\\info.png", width=220, height=220, dim=50 }

-- function to manage the page
local function getDimension (w, h, percWith, margin)
	percWith = percWith or 100
	margin = margin or margins

	local maxWidth = (( display.contentWidth / 100 ) * percWith ) - margin*2
	local ratio = maxWidth / w
	local finalH = h * ratio

	return maxWidth, finalH
end

local function getPosition (data)
	return display.contentWidth*data.x, display.contentHeight*data.y
end

-- Function to handle button events
local function infoButtonClick( event )
	if ( "ended" == event.phase ) then
        print( "Pagina delle info" )
    end
end

-- UI 
bg = display.newImageRect( image.path, display.contentWidth, display.contentHeight )
bg.x, bg.y = getPosition(image)

local hdW, hdH = getDimension(headImage.width, headImage.height, 80)
header = display.newImageRect( headImage.path, hdW, hdH )
header.x, header.y = getPosition(headImage)

local bbW, bbH = getDimension(whiteBG.width, whiteBG.height, 95, 0)
contentBox = display.newImageRect( whiteBG.path, bbW, bbH )
contentBox.x, contentBox.y = getPosition(whiteBG)

info = widget.newButton({
	id = "infoBtn",
	width = infoBtn.dim,
	height = infoBtn.dim,
	left = display.contentWidth - infoBtn.dim - margins,
	top = display.contentHeight - infoBtn.dim - margins,
	fillColor = transparent,
	defaultFile = infoBtn.path,
	onEvent = infoButtonClick
})
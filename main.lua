-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- requires
local widget = require( "widget" )

-- elements init
local bg, info, header, contentBox, playBtn, pauseBtn, refreshBtn, timeTxt

-- colors
local transparent = { default={ 1, 1, 1, 0 }, over={ 1, 1, 1, 0 } }

-- dimensions
local margins = 5

-- times
_G.timeInSecond = 60
local timeActive = _G.timeInSecond

-- images
local image = { path="images\\defaultbg.png", width=1080, height=1920, x=0.5, y=0.5 }
local headImage = { path="images\\header.png", width=933, height=553, x=0.5, y=0.2 }
local whiteBG = { path="images\\boxbianco.png", width=1025, height=800, x=0.5, y=0.6 }
local infoBtn = { path="images\\btn\\info.png", width=220, height=220, dim=50 }
local play = { path="images\\btn\\play.png", width=500, height=500, dim=150, x=0.5, y=0.7 }
local pause = { path="images\\btn\\pausa.png", width=500, height=500, dim=150, x=0.5, y=0.7 }
local refresh = { path="images\\btn\\refresh.png", width=500, height=500, dim=75, x=0.2, y=0.72 }
local time = { x=0.5, y=0.5, fontSize=40, color={0,0,0} }

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
	local offset = {
		top = data.top or 0,
		left = data.left or 0,
		bottom = data.bottom or 0,
		right = data.right or 0
	}

	local x = (display.contentWidth*data.x)+offset.right-offset.left
	local y = (display.contentHeight*data.y)+offset.top-offset.bottom
	return x, y
end

local function formatText (time)
	local function getLetter (t)
		if (t >= 3600) then
			return "h"
		elseif (t < 3600 and t >= 60) then
			return "m"
		else
			return "s"
		end
	end

	local k = getLetter(time)
	
	local h = math.floor(time / 3600)
	time = time - (h * 3600)
	local m = math.floor(time / 60)
	time = time - (m * 60)
	local s = time

	if (h == 0) then
		h = ""
	else
		h = h .. ":"
	end

	if ((m >= 10) or (m < 10 and m ~= 0 and h == "")) then
		m = m .. ":"
	elseif (m < 10 and h ~= "") then
		m = "0" .. m .. ":"
	else
		m = ""
	end

	if (s < 10) then
		s = "0" .. s
	end

	return h .. m .. s .. " " .. k
end

-- Function to handle button events
local function infoButtonClick( event )
	if ( "ended" == event.phase ) then
        print( "Pagina delle info" )
    end
end

local function playClick (event)
	if ( "ended" == event.phase ) then
        playBtn.isVisible = false
        pauseBtn.isVisible = true
    end
end

local function pauseClick (event)
	if ( "ended" == event.phase ) then
        playBtn.isVisible = true
        pauseBtn.isVisible = false
    end
end

local function refreshClick (event)
	if ( "ended" == event.phase ) then
		refreshBtn.isVisible = false
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

playBtn = widget.newButton({
	id = "btnPlay",
	width = play.dim,
	height = play.dim,
	fillColor = transparent,
	defaultFile = play.path,
	onEvent = playClick
})
playBtn.x, playBtn.y = getPosition(play)

pauseBtn = widget.newButton({
	id = "btnPause",
	width = pause.dim,
	height = pause.dim,
	fillColor = transparent,
	defaultFile = pause.path,
	onEvent = pauseClick
})
pauseBtn.x, pauseBtn.y = getPosition(pause)
pauseBtn.isVisible = false

refreshBtn = widget.newButton({
	id = "btnRefresh",
	width = refresh.dim,
	height = refresh.dim,
	fillColor = transparent,
	defaultFile = refresh.path,
	onEvent = refreshClick
})
refreshBtn.x, refreshBtn.y = getPosition(refresh)
refreshBtn.isVisible = false

-- Time text init
timeTxt = display.newText({
	text = formatText(timeActive),
	width = bbW,
	height = 0,
	font = native.newFont(),
	fontSize = time.fontSize,
	align = "center"
})
timeTxt.x, timeTxt.y = getPosition(time)
timeTxt:setFillColor(time.color)
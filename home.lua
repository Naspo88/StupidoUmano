-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- requires
local widget = require( "widget" )
local composer = require( "composer" )
local g = require( "globals" )

-- create scene
local scene = composer.newScene()

-- elements init
local bg, info, header, contentBox, playBtn, pauseBtn, refreshBtn, timeTxt, tm, rem

-- colors
local transparent = { default={ 1, 1, 1, 0 }, over={ 1, 1, 1, 0 } }

-- times
local timeActive = g.timeInSecond
local step = 1000

local space = 25

-- images
local image = { path="images\\defaultbg.png", width=1080, height=1920, x=0.5, y=0.5 }
local headImage = { path="images\\header.png", width=933, height=553, x=0.5, y=0.2 }
local whiteBG = { path="images\\boxbianco.png", width=1025, height=800, x=0.5, y=0.6 }
local infoBtn = { path="images\\btn\\info.png", width=220, height=220, dim=50 }
local play = { path="images\\btn\\play.png", width=500, height=500, dim=150, x=0.5, y=0.7 }
local pause = { path="images\\btn\\pausa.png", width=500, height=500, dim=150, x=0.5, y=0.7 }
local refresh = { path="images\\btn\\refresh.png", width=500, height=500, dim=75, x=0.2, y=0.72 }
local time1 = { x=0.55, y=0.5, fontSize=90, color={0,0,0} }

-- function to manage the page
local function changeTime (event)
	timeActive = timeActive - 1

	if (timeActive > 0) then
		g.formatText(timeActive, timeTxt)
		tm = timer.performWithDelay( step, changeTime, 1 )
	else
		tm = nil
		g.formatText(timeActive, timeTxt)

		playBtn.isVisible = false
        pauseBtn.isVisible = false
        refreshBtn.isVisible = true
	end

end

-- Function to handle button events
local function infoButtonClick( event )
	if ( "began" == event.phase ) then
		info:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		info:scale( 1/g.scale, 1/g.scale )
    elseif ( "ended" == event.phase ) then
       	info:scale( 1/g.scale, 1/g.scale )

       	composer.removeScene( "info" )
       	local options = {
		    effect = "fade",
		    time = 500
		}
		composer.gotoScene( "info", options )
    end
end

local function playClick (event)
	if ( "ended" == event.phase ) then
        playBtn.isVisible = false
        pauseBtn.isVisible = true

        if (tm == nil) then
        	tm = timer.performWithDelay( step, changeTime, 1 )
        else
        	refreshBtn.isVisible = false
        	timer.resume( tm )
        end
    end
end

local function pauseClick (event)
	if ( "ended" == event.phase ) then
        playBtn.isVisible = true
        pauseBtn.isVisible = false

        if ( timeActive < g.timeInSecond) then
        	refreshBtn.isVisible = true
        end

        timer.pause( tm )
    end
end

local function refreshClick (event)
	if ( "ended" == event.phase ) then
		refreshBtn.isVisible = false

		if ( tm ) then
			timer.cancel( tm )
		end
		timeActive = g.timeInSecond
		g.formatText(timeActive, timeTxt)
		tm = nil

		playBtn.isVisible = true
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view

end

-- show()
function scene:show( event )

    local sceneGroup = self.view

    -- UI 
	bg = display.newImageRect( image.path, display.contentWidth, display.contentHeight )
	bg.x, bg.y = g.getPosition(image)

	local hdW, hdH = g.getDimension(headImage.width, headImage.height, 80)
	header = display.newImageRect( headImage.path, hdW, hdH )
	header.x, header.y = g.getPosition(headImage)

	local bbW, bbH = g.getDimension(whiteBG.width, whiteBG.height, 95, 0)
	contentBox = display.newImageRect( whiteBG.path, bbW, bbH )
	contentBox.x, contentBox.y = g.getPosition(whiteBG)

	info = widget.newButton({
		id = "infoBtn",
		width = infoBtn.dim,
		height = infoBtn.dim,
		left = display.contentWidth - infoBtn.dim - g.margins,
		top = display.contentHeight - infoBtn.dim - g.margins,
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
	playBtn.x, playBtn.y = g.getPosition(play)

	pauseBtn = widget.newButton({
		id = "btnPause",
		width = pause.dim,
		height = pause.dim,
		fillColor = transparent,
		defaultFile = pause.path,
		onEvent = pauseClick
	})
	pauseBtn.x, pauseBtn.y = g.getPosition(pause)
	pauseBtn.isVisible = false

	refreshBtn = widget.newButton({
		id = "btnRefresh",
		width = refresh.dim,
		height = refresh.dim,
		fillColor = transparent,
		defaultFile = refresh.path,
		onEvent = refreshClick
	})
	refreshBtn.x, refreshBtn.y = g.getPosition(refresh)
	refreshBtn.isVisible = false

	-- Time text init
	timeTxt = display.newText({
		text = "",
		width = bbW - g.margins * 8,
		height = 0,
		font = g.timeFont,
		fontSize = time1.fontSize,
		align = "center"
	})
	timeTxt.x, timeTxt.y = g.getPosition(time1)
	timeTxt:setFillColor(time1.color)

    g.formatText(timeActive, timeTxt)
end


-- -- hide()
function scene:hide( event )

    local sceneGroup = self.view

end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
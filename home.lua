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
local bg, info, header, contentBox, playBtn, pauseBtn, refreshBtn, timeTxt, tm, rem, showCat
local cats = {}

-- colors
local transparent = { default={ 1, 1, 1, 0 }, over={ 1, 1, 1, 0 } }

-- times
local timeActive = g.timeInSecond
local step = 980
local baseCats = "images\\cats\\"

local space = 25

-- images
local image = { path="images\\defaultbg.png", width=1080, height=1920, x=0.5, y=0.5 }
local headImage = { path="images\\header.png", width=933, height=553, x=0.5, y=0.2 }
local whiteBG = { path="images\\boxbianco.png", width=1025, height=800, x=0.5, y=0.6 }
local infoBtn = { path="images\\btn\\info.png", width=220, height=220, dim=50 }
local play = { path="images\\btn\\play.png", width=500, height=500, dim=150, x=0.5, y=0.7 }
local pause = { path="images\\btn\\pausa.png", width=500, height=500, dim=150, x=0.5, y=0.7 }
local refresh = { path="images\\btn\\refresh.png", width=500, height=500, dim=75, x=0.2, y=0.72 }
local time1 = { x=0.55, y=0.5, fontSize=90, color=g.colorContent }
local allCats = {
	{ path= baseCats .. "ciccionebonzo.png", width=1200, height=1200 },
	{ path= baseCats .. "gattabianca.png", width=1200, height=1379 },
	{ path= baseCats .. "gattino.png", width=1200, height=1395 },
	{ path= baseCats .. "gattonero.png", width=1200, height=1379 },
	{ path= baseCats .. "randagio.png", width=1200, height=979 },
	{ path= baseCats .. "selvaggia.png", width=1200, height=1395 }
}

-- function to manage the page
local function toggleRandomCat ()
	if (showCat) then
		g.hidethis(cats[showCat])
	end

	local newRandom = math.random(table.maxn(cats))

	if (showCat == newRandom) then
		newRandom = newRandom + 1
		if (newRandom > table.maxn(cats)) then
			newRandom = 1
		end
	end

	showCat = newRandom

	cats[showCat].x, cats[showCat].y = g.getRandomPosition()
	g.showthis(cats[showCat], 1)
end

local function changeTime (event)
	timeActive = timeActive - 1

	if (timeActive > 0) then
		g.formatText(timeActive, timeTxt)
		tm = timer.performWithDelay( step, changeTime, 1 )

		if (timeActive % 10 == 0) then
			toggleRandomCat()
		end
	else
		tm = nil
		g.formatText(timeActive, timeTxt)

		g.endTime()

		g.enableBtn(playBtn, false)
		g.enableBtn(pauseBtn, false)
		g.enableBtn(refreshBtn, true)
	end

end

-- Function to handle button events
local function infoButtonClick( event )
	if ( "began" == event.phase ) then
		info:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		info:scale( 1/g.scale, 1/g.scale )
	elseif ( "moved" == event.phase ) then
		-- Do nothing
    elseif ( "ended" == event.phase ) then
       	info:scale( 1/g.scale, 1/g.scale )
       	g.btnPress()

       	if ( tm ) then
			timer.cancel( tm )
		end

       	composer.removeScene( "info" )
       	local options = {
		    effect = "fade",
		    time = 500
		}
		composer.gotoScene( "info", options )
    end
end

local function playClick (event)
	print (event.phase .. " play")
	if ( "began" == event.phase ) then
		playBtn:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		playBtn:scale( 1/g.scale, 1/g.scale )
	elseif ( "moved" == event.phase ) then
		-- Do nothing
    elseif ( "ended" == event.phase ) then
       	playBtn:scale( 1/g.scale, 1/g.scale )

       	g.enableBtn(playBtn, false)
		g.enableBtn(pauseBtn, true)

        g.btnPress()

        if (tm == nil) then
        	tm = timer.performWithDelay( step, changeTime, 1 )

        	g.hidethis(header)
        	toggleRandomCat()
        else
        	g.enableBtn(refreshBtn, false)
        	timer.resume( tm )
        end
    end
end

local function pauseClick (event)
	print (event.phase .. " pause")
	if ( "began" == event.phase ) then
		pauseBtn:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		pauseBtn:scale( 1/g.scale, 1/g.scale )
	elseif ( "moved" == event.phase ) then
		-- Do nothing
    elseif ( "ended" == event.phase ) then
       	pauseBtn:scale( 1/g.scale, 1/g.scale )

        g.enableBtn(playBtn, true)
		g.enableBtn(pauseBtn, false)

        g.btnPress()

        if ( timeActive <= g.timeInSecond) then
			g.enableBtn(refreshBtn, true)
        end

        timer.pause( tm )
    end
end

local function refreshClick (event)
	if ( "began" == event.phase ) then
		refreshBtn:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		refreshBtn:scale( 1/g.scale, 1/g.scale )
	elseif ( "moved" == event.phase ) then
		-- Do nothing
    elseif ( "ended" == event.phase ) then
       	refreshBtn:scale( 1/g.scale, 1/g.scale )

		g.enableBtn(refreshBtn, false)

		g.btnPress()

		if ( tm ) then
			timer.cancel( tm )
		end

		timeActive = g.timeInSecond
		g.formatText(timeActive, timeTxt)
		tm = nil

		for i = 1, table.maxn(cats) do
			cats[i].alpha = 0
		end

		g.enableBtn(playBtn, true)
		header.alpha = 1
		showCat = nil
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

    if ( event.phase == "did" ) then

	    -- UI 
		bg = display.newImageRect( image.path, display.contentWidth, display.contentHeight )
		bg.x, bg.y = g.getPosition(image)

		for i = 1, table.maxn(allCats) do
			local dw, dh = g.getDimension(allCats[i].width, allCats[i].height, 110)
			cats[i] = display.newImageRect( allCats[i].path, dw, dh )
			cats[i].x, cats[i].y = g.getRandomPosition()
			cats[i].alpha = 0
		end

		local hdW, hdH = g.getDimension(headImage.width, headImage.height, 95)
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
		g.enableBtn(pauseBtn, false)

		refreshBtn = widget.newButton({
			id = "btnRefresh",
			width = refresh.dim,
			height = refresh.dim,
			fillColor = transparent,
			defaultFile = refresh.path,
			onEvent = refreshClick
		})
		refreshBtn.x, refreshBtn.y = g.getPosition(refresh)
		g.enableBtn(refreshBtn, false)

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
		timeTxt:setFillColor(unpack(time1.color))

	    g.formatText(timeActive, timeTxt)

	    composer.removeScene( "info" )
	end
end


-- -- hide()
function scene:hide( event )

    local sceneGroup = self.view

end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view

    info = g.fullDestroy(info)
    playBtn = g.fullDestroy(playBtn)
    pauseBtn = g.fullDestroy(pauseBtn)
    refreshBtn = g.fullDestroy(refreshBtn)

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
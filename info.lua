-----------------------------------------------------------------------------------------
--
-- info.lua
--
-----------------------------------------------------------------------------------------
-- requires
local widget = require( "widget" )
local composer = require( "composer" )
local g = require( "globals" )

-- create scene
local scene = composer.newScene()

-- elements init
local bg, topBox, bottomBox, goback, timeTxt, menoBtn, piuBtn
local infoTit = {}
local infoCont = {}

-- images
local image = { path="images\\defaultbg.png", width=1080, height=1920, x=0.5, y=0.5 }
local topWbg = { path="images\\boxTop.png", width=1041, height=384, x=0.5, y=0.125 }
local bottomWbg = { path="images\\boxBottom.png", width=1041, height=1456, x=0.5, y=0.605 }
local headImage = { path="images\\header.png", width=933, height=553, x=0.5, y=0.33 }
local backBtn = { path="images\\btn\\indietro.png", width=206, height=190, dim=60 }
local time1 = { x=0.525, y=0.115, fontSize=60, color=g.colorContent }
local lessTime = { path="images\\btn\\meno.png", width=270, height=270, dim=80, x=0.15, y=0.125 }
local moreTime = { path="images\\btn\\piu.png", width=270, height=270, dim=80, x=0.85, y=0.125 }

-- text
local var = 0.085
local base = 0.45
local fS = 17
local c = 0.5
local allInfoText = {
	{ title = "app realizzata da:", content = "Flux Entertainment", fs = fS, x = c, y = base + (var * 0)},
	{ title = "da un'idea di:", content = "Viviana De Simone", fs = fS, x = c, y = base + (var * 1)},
	{ title = "game design:", content = "Christian Zoli", fs = fS, x = c, y = base + (var * 2)},
	{ title = "sviluppo e editing:", content = "Viviana De Simone", fs = fS, x = c, y = base + (var * 3)},
	{ title = "grafica e art direction:", content = "Silvia Diaferia", fs = fS, x = c, y = base + (var * 4)},
	{ title = "illustrazioni:", content = "Marco Fabbri", fs = fS, x = c, y = base + (var * 5)}
}

-- Function to handle button events
local function backClick( event )
	if ( "began" == event.phase ) then
		goback:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		goback:scale( 1/g.scale, 1/g.scale )
    elseif ( "ended" == event.phase ) then
       	goback:scale( 1/g.scale, 1/g.scale )

       	composer.removeScene( "home" )
       	local options = {
		    effect = "fade",
		    time = 500
		}
		composer.gotoScene( "home", options )
    end
end

local function menoBtnFn( event )
	if ( "began" == event.phase ) then
		menoBtn:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		menoBtn:scale( 1/g.scale, 1/g.scale )
    elseif ( "ended" == event.phase ) then
       	menoBtn:scale( 1/g.scale, 1/g.scale )

       	piuBtn.isVisible = true
       	g.timeInSecond = g.timeInSecond - 30

       	if (g.timeInSecond == 30) then
       		menoBtn.isVisible = false
       	end

       	g.formatText(g.timeInSecond, timeTxt)
    end
end

local function piuBtnFn( event )
	if ( "began" == event.phase ) then
		piuBtn:scale( g.scale, g.scale )
	elseif ( "cancelled" == event.phase ) then
		piuBtn:scale( 1/g.scale, 1/g.scale )
    elseif ( "ended" == event.phase ) then
       	piuBtn:scale( 1/g.scale, 1/g.scale )

       	menoBtn.isVisible = true
       	g.timeInSecond = g.timeInSecond + 30

       	if (g.timeInSecond == 600) then
       		piuBtn.isVisible = false
       	end

       	g.formatText(g.timeInSecond, timeTxt)
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

		local bbW, bbH = g.getDimension(topWbg.width, topWbg.height, 95, 0)
		topBox = display.newImageRect( topWbg.path, bbW, bbH )
		topBox.x, topBox.y = g.getPosition(topWbg)

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

		menoBtn = widget.newButton({
			id = "menoBtn",
			width = lessTime.dim,
			height = lessTime.dim,
			fillColor = transparent,
			defaultFile = lessTime.path,
			onEvent = menoBtnFn
		})
		menoBtn.x, menoBtn.y = g.getPosition(lessTime)
		menoBtn.isVisible = (g.timeInSecond ~= 30)

		piuBtn = widget.newButton({
			id = "piuBtn",
			width = moreTime.dim,
			height = moreTime.dim,
			fillColor = transparent,
			defaultFile = moreTime.path,
			onEvent = piuBtnFn
		})
		piuBtn.x, piuBtn.y = g.getPosition(moreTime)
		piuBtn.isVisible = (g.timeInSecond ~= 600)

		local bb2W, bb2H = g.getDimension(bottomWbg.width, bottomWbg.height, 95, 0)
		bottomBox = display.newImageRect( bottomWbg.path, bb2W, bb2H )
		bottomBox.x, bottomBox.y = g.getPosition(bottomWbg)

		local hdW, hdH = g.getDimension(headImage.width, headImage.height, 50)
		header = display.newImageRect( headImage.path, hdW, hdH )
		header.x, header.y = g.getPosition(headImage)

		goback = widget.newButton({
			id = "goBack",
			width = backBtn.dim,
			height = backBtn.dim,
			left = display.contentWidth - backBtn.dim - g.margins * 5,
			top = display.contentHeight - backBtn.dim - g.margins * 5,
			fillColor = transparent,
			defaultFile = backBtn.path,
			onEvent = backClick
		})

		for i = 1, table.maxn(allInfoText) do
			infoTit[i] = display.newText({
				text = allInfoText[i].title,
				width = bb2W - g.margins,
				height = 0,
				font = g.infoFont,
				fontSize = allInfoText[i].fs,
				align = "center"
			})
			infoTit[i].x, infoTit[i].y = g.getPosition(allInfoText[i])
			infoTit[i]:setFillColor(unpack(g.colorTitle))

			infoCont[i] = display.newText({
				text = string.upper(allInfoText[i].content),
				width = bb2W - g.margins,
				height = 0,
				font = g.infoFont,
				fontSize = allInfoText[i].fs,
				align = "center"
			})
			infoCont[i].x, infoCont[i].y = g.getPosition(allInfoText[i], true)
			infoCont[i]:setFillColor(unpack(g.colorContent))
		end

		g.formatText(g.timeInSecond, timeTxt)
	end

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
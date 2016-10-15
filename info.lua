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
local bg

-- images
local image = { path="images\\defaultbg.png", width=1080, height=1920, x=0.5, y=0.5 }

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
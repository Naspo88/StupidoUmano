-----------------------------------------------------------------------------------------
--
-- info.lua
--
-----------------------------------------------------------------------------------------
-- requires
local composer = require( "composer" )

-- create scene
local scene = composer.newScene()

-- elements init
local splashscreen

-- images
local image = { path="images/splash.png", width=1080, height=1920, x=0.5, y=0.5 }


-- Function to handle button events
local function goToMenu ()
	composer.gotoScene( "home", "fade", 500 )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view

    splashscreen = display.newImageRect( image.path, display.contentWidth, display.contentHeight )
	splashscreen.anchorX = 0
	splashscreen.anchorY = 0
	splashscreen.x, splashscreen.y = 0, 0
	
	sceneGroup:insert( splashscreen )

end

-- show()
function scene:show( event )

    local sceneGroup = self.view

    if ( event.phase == "did" ) then

	    timer.performWithDelay( 2000, goToMenu, 1 )
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
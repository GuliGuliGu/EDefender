
local composer = require( "composer" )
require ("DV")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local fonMusik

local name

local startGame
local exitGame

local function PlayGame( )
	composer.gotoScene( "game", {time = 500, effect = "fade"} )
end

local function ExitGame(  )
	native.requestExit( )
end

local function WTFisGoinOn( )
	composer.gotoScene( "wtf", {time = 500, effect = "fade"} )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
	local BG = display.newRect( sceneGroup, C_X, C_Y, display.actualContentWidth, display.actualContentHeight)
    BG.fill = 
    {
        type = "image", filename = "st.png"
    }
    BG.fill.scaleX = 0.2
    BG.fill.scaleY = 0.2

	fonMusik = audio.loadStream( "fon.mp3" )

	name = display.newText(sceneGroup, "Earth Defender", C_X, C_Y - 200, font, 75)
	name:setFillColor( 1, 1, 1 )

	PlayBatonText = display.newText( sceneGroup, "PLAY", C_X, C_Y + 50, font, 40 )
   PlayBatonText:setFillColor( 1,1,1 )
   PlayBatonText.fon1 = display.newRoundedRect(sceneGroup, PlayBatonText.x, PlayBatonText.y, 200, PlayBatonText.height + 10, 10 )
   PlayBatonText.fon1:setFillColor( 1,1,1 )
    PlayBatonText.fon2 = display.newRoundedRect(sceneGroup, PlayBatonText.x, PlayBatonText.y, PlayBatonText.fon1.width - 10, PlayBatonText.fon1.height - 10, 5 )
   PlayBatonText:toFront( )



WTFBatonText = display.newText( sceneGroup, "WTF", C_X, C_Y + 125, font, 40 )
   WTFBatonText:setFillColor( 1,1,1 )
   WTFBatonText.fon1 = display.newRoundedRect(sceneGroup, WTFBatonText.x, WTFBatonText.y, 200, WTFBatonText.height + 10, 10 )
   WTFBatonText.fon1:setFillColor( 1,1,1 )
    WTFBatonText.fon2 = display.newRoundedRect(sceneGroup, WTFBatonText.x, WTFBatonText.y, WTFBatonText.fon1.width - 10, WTFBatonText.fon1.height - 10, 5 )
   WTFBatonText:toFront( )

   

	ExitBatonText = display.newText( sceneGroup, "EXIT", C_X, C_Y + 300, font, 40 )
   ExitBatonText:setFillColor( 1,1,1 )
   ExitBatonText.fon1 = display.newRoundedRect(sceneGroup, ExitBatonText.x, ExitBatonText.y, ExitBatonText.width + 30, ExitBatonText.height + 10, 10 )
   ExitBatonText.fon1:setFillColor( 1,1,1 )
    ExitBatonText.fon2 = display.newRoundedRect(sceneGroup, ExitBatonText.x, ExitBatonText.y, ExitBatonText.fon1.width - 10, ExitBatonText.fon1.height - 10, 5 )
   ExitBatonText:toFront( )

	

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		--audio.play(fonMusik, {channel = 1, loops = -1})
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	PlayBatonText.fon1:addEventListener( "tap", PlayGame )
	ExitBatonText.fon1:addEventListener( "tap", ExitGame )
	WTFBatonText.fon1:addEventListener( "tap", WTFisGoinOn )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		--composer.removeScene( "menu" )
		
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		audio.stop( 1 )
		
		composer.removeScene( "menu" )
		

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( "fon.mp3" )

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

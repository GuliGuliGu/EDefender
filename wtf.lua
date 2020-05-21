
local composer = require( "composer" )

local virovn = require("justify")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local ExitBatonText
local fuckingText

local function goback(  )
	composer.gotoScene( "menu" , {time = 500, effect = "fade"} )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	--fuckingText = display.newText( {parent = sceneGroup, text = "In the future not so far away, Ilon Mask commenced the colonisation of Mars. Space beetles were not amused by this development, they began to fear that pesky humans would soon reach them at such pace. Tiny bug minds didn't come up with anything better than starting throwing meteorites in the Earth's general direction, but Ilon wasn't stumped. Thanks to the Ukrainian engineering efforts, a ship the size of the country was launched into space... However it soon became apparent that it was too massive to leave the orbit. Probably. I am not good ot this backstory chit chat, you, the pilot, will have to wind around the Earth protecting it from incoming meteorites. \nGood luck. \n\nCode - Pomoinyi Enot \nPictures - RaptorMikhalych \nMusic - wav-library.net \nSound effects by Eric Matyas. www.soundimage.org   \n \nP.S. I know this it terribly... sorry) ", x = C_X, y =  _Y, width = display.actualContentWidth - 50,  font = font, fontSize = 40, align = "center"} )
	--fuckingText.anchorY = 0
	--fuckingText:setFillColor( 1,1,1 )
	--fuckingText.align = "right"

fuckingText = virovn.justifyFull({maxWidth = display.actualContentWidth - 50, text = "In the future not so far away, Ilon Mask commenced the colonisation of Mars. Space beetles were not amused by this development, they began to fear that pesky humans would soon reach them at such pace. Tiny bug minds didn't come up with anything better than starting throwing meteorites in the Earth's general direction, but Ilon wasn't stumped. Thanks to the Ukrainian engineering efforts, a ship the size of the country was launched into space... However it soon became apparent that it was too massive to leave the orbit. Probably. I am not good ot this backstory chit chat, you, the pilot, will have to wind around the Earth protecting it from incoming meteorites.", font = font, fontSize = 40})


fuckingText.x, fuckingText.y = display.safeScreenOriginX + 25, display.actualContentHeight

sceneGroup:insert(fuckingText)

fuckingText.sector2 = display.newText( {parent = fuckingText, text = "\nGood luck. \nCode - Pomoinyi Enot \nPictures - RaptorMikhalych \nMusic - wav-library.net \nSound effects by Eric Matyas. www.soundimage.org   \n \nP.S. I know this it terribly... sorry) ", x = display.actualContentWidth/2, y =  fuckingText.height, width = display.actualContentWidth - 50,  font = font, fontSize = 40, align = "center"} )
	fuckingText.sector2.anchorY = 0
	fuckingText.sector2.anchorX = 0.5

fuckingText.sector2:setFillColor( 1,1,1 )


	-- Code here runs when the scene is first created but has not yet appeared on screen
	ExitBatonText = display.newText( sceneGroup, "Back", C_X, display.actualContentHeight - 50, font, 40 )
   ExitBatonText:setFillColor( 1,1,1 )
   ExitBatonText.fon1 = display.newRoundedRect(sceneGroup, ExitBatonText.x, ExitBatonText.y, ExitBatonText.width + 20, ExitBatonText.height + 10, 10 )
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

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		ExitBatonText.fon1:addEventListener( "tap", goback )

		transition.to( fuckingText, {time = 65000, y = fuckingText.y - fuckingText.height*2} )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "wtf" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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

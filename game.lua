
local composer = require( "composer" )
require("DV")
local LS = require("loadsave")

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()  -- Start the physics engine
physics.setGravity( 0, 0 )  -- Set "space" gravity
physics.setDrawMode( "hybrid" )

math.randomseed( os.time() )  -- Seed the pseudo-random number generator
 
-- Set radial gravity simulation values
local field --гравитационное поле
local fieldRadius = C_X --радиус действия планеты
local fieldPower = 0.07 -- сила гравитации

local font = "arial"

-----------------------------------------------------------------------------------
local planetSheetOptions = {
    width = 440,
    height = 440, 
    numFrames = 10
}
display.setDefault( "textureWrapX", "clampToEdge" )
display.setDefault( "textureWrapY", "clampToEdge" )

local planetSheet = graphics.newImageSheet( "bitch.png", planetSheetOptions )
local something = {start = 1,
        count = 10,
        time = 2000,
        loopCount = 0}

local planet  -- планета
local planetHPtextW -- хп планеты текст
local planetHPtextB
 
local allPlanetHP = 20
local planetHP = allPlanetHP --хп планеты
local planetHPline
local planetHPcontainer

local score = 0 
local scoreText 

local asteroidsTable = {} -- астероиды





local radius = 80
local degrees = -180


local ship
local allShipHP = 20
local shipHP = allShipHP
local shipHPtextW
local shipHPtextB
local shipHPline
local shipHPcontainer
local died = false


local UIGroup

local gameOverGroup

local mainGroup



local gameOver



local fire = false
local fireSound = audio.loadSound( "fire.wav" )
local explousion = audio.loadSound("explosion.wav")
-- -----------------------------------------------------------------------------------
-- Scene event functions


local function angle(x1,y1, x2, y2)  
    return math.deg(math.acos((x1*x2+y1*y2)/(((x1^2+y1^2)^0.5)*((x2^2+y2^2)^0.5))))
end

local textGroup

local function damage (OBJx, OBJy, minusHP)
     textGroup = display.newGroup( )
     UIGroup:insert( textGroup )
     local fuckingTextFront = display.newText(textGroup, minusHP, OBJx, OBJy, font, 30)
    fuckingTextFront:setFillColor( 1,1,1 )

    local fuckingTextBackR = display.newText(textGroup, minusHP, fuckingTextFront.x+2, fuckingTextFront.y, font, 30)
    fuckingTextBackR:setFillColor( 0, 0, 0 )
    local fuckingTextBackL = display.newText(textGroup, minusHP, fuckingTextFront.x-2, fuckingTextFront.y, font, 30)
    fuckingTextBackL:setFillColor( 0, 0, 0 )
    local fuckingTextBackU = display.newText(textGroup, minusHP, fuckingTextFront.x, fuckingTextFront.y-2, font, 30)
    fuckingTextBackU:setFillColor( 0, 0, 0 )
    local fuckingTextBackD = display.newText(textGroup, minusHP, fuckingTextFront.x, fuckingTextFront.y+2, font, 30)
    fuckingTextBackD:setFillColor( 0, 0, 0 )
   
   fuckingTextFront:toFront( )

   --print(OBJy)
   transition.to(textGroup, {time = 500, y = OBJy - 50 - OBJy, alpha = 0 })
end


local function bangbang( )

	if fire == true then
		audio.play( fireSound )
		local newLaser = display.newRect(mainGroup,  0,0,  10, 5 )
	    physics.addBody( newLaser, "static", { isSensor=true } )
	    newLaser:setFillColor(1,1,1)
	    newLaser.isBullet = true
	    newLaser.myName = "laser"
	    newLaser.x = ship.x
    	newLaser.y = ship.y
    	newLaser:toBack()
    	if newLaser.y < C_Y then
			newLaser.rotation = ( angle(-0.1,0, newLaser.x - C_X, newLaser.y - C_Y) )
		elseif newLaser.y > C_Y then
			newLaser.rotation = ( angle(0.1,0, newLaser.x - C_X, newLaser.y - C_Y) ) - 180
		end
 
 		if ship ~= nil and newLaser ~=nil then
    	   transition.to( newLaser, {x = C_X + (ship.x - C_X) * 5 , y= C_Y + (ship.y - C_Y) * 5  , time=1000}) 
    	   
           timer.performWithDelay( 800, function ( )
               transition.to(  newLaser, {time = 200, alpha = 0, onComplete = function ( )
                   display.remove( newLaser )
               end} ) 
            
                    
                
            
    		end) 
    	end
	end
end



local function drawRects(degrees)
    local rads = (ship.degStart + degrees) * (math.pi / 180.0)
    ship.x = radius * math.cos(rads) + C_X
    ship.y = radius * math.sin(rads) + C_Y

    
end

local function getDegrees(ship)
    local x = ship.x
    local y = ship.y

    local degrees = math.atan2((y - C_Y) , (x - C_X)) * (180 / math.pi)

    return degrees
end


local firstShoot = true

local function onTouch( event )
  

    local phase = event.phase
   
    if "began" == phase then
        

    
        if firstShoot == true then
            fire = true
            bangbang()
            fire = false
            firstShoot = false
            timer.performWithDelay( 450, function ( )
                firstShoot = true
            end )
        end

       
       fire = true
       


       
        uuu_suka = timer.performWithDelay( 500, bangbang, 0 )
       
      

        

        ship.degStart = getDegrees(ship)
        
    
    elseif "moved" == phase and ship ~= nil then
        degrees = math.atan2((event.yStart - C_Y) , (event.xStart - C_X)) * (180 / math.pi)

        degrees2 = math.atan2((event.y - C_Y) , (event.x - C_X)) * (180 / math.pi)

        diffDegrees = degrees2 - degrees
        drawRects(diffDegrees)

        


       
        if ship.y < C_Y then
			ship.rotation = ( angle(-0.1,0, ship.x - C_X, ship.y - C_Y) )
		elseif ship.y > C_Y then
			ship.rotation = ( angle(0.1,0, ship.x - C_X, ship.y - C_Y) ) - 180
		end

		


    elseif "ended" == phase or "cancelled" == phase then

        if uuu_suka ~= nil then
            timer.pause(uuu_suka)  
        end
        
        fire = false 
    end
    
return true
end








--[[

local function collideWithField( self, event )
 
    local objectToPull = event.other

    print( objectToPull.myName )
 
    if ( event.phase == "began" and objectToPull.touchJoint == nil and objectToPull ~= nil) then
 
        -- Create touch joint after short delay (10 milliseconds)
        timer.performWithDelay( 1,
            function()
                -- Create touch joint
                if objectToPull ~= nil and objectToPull.touchJoint == nil then 
                    objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                    -- Set physical properties of touch joint
                    objectToPull.touchJoint.frequency = fieldPower
                    objectToPull.touchJoint.dampingRatio = 0.0
                    -- Set touch joint "target" to center of field
                    objectToPull.touchJoint:setTarget( self.x, self.y )
                end
            end
        )
 
    elseif ( event.phase == "ended" and objectToPull.touchJoint ~= nil ) then
 
        objectToPull.touchJoint:removeSelf()
        objectToPull.touchJoint = nil
    end
end
]]

local function createAsteroid()
 
    local newAsteroid = display.newImageRect(mainGroup, "test.png", 30, 30 )

    newAsteroid:setFillColor(1,1,1)
    table.insert( asteroidsTable, newAsteroid )
    physics.addBody( newAsteroid, "dynamic", { radius = newAsteroid.width * 0.5} )
    newAsteroid.myName = "asteroid"

    local whereFrom = math.random( 3 )
 
    if ( whereFrom == 1 ) then
        -- From the left
        newAsteroid.x = -60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newAsteroid.x = math.random( _X )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newAsteroid.x = _X + 60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end

    newAsteroid:applyTorque( math.random(-5, 5 )/100 )

end


local function gameLoop()
 
    -- Create new asteroid
    createAsteroid()
 
    -- Remove asteroids which have drifted off screen
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]
 
        if ( thisAsteroid.x ~= nil and (
             thisAsteroid.x < -65 or
             thisAsteroid.x > _X + 65 or
             thisAsteroid.y < -65 or
             thisAsteroid.y > _Y + 65) )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
    end
end



local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if  ( obj1.myName == "planet" and obj2.myName == "asteroid" ) 
        then
            -- Remove both the laser and asteroid

            damage(obj2.x, obj2.y, -10)-----------------------------------------------
            audio.play(explousion)
            display.remove( obj2 )

       	 	for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj2 ) then
                    
                    if asteroidsTable[i].touchJoint ~= nil and asteroidsTable[i] ~= nil then
                        asteroidsTable[i].touchJoint = nil
                    end
                    table.remove( asteroidsTable, i )
                    break
                end
        	end

            

        	planetHP = planetHP - 10
           -- print("PLANET HP = " .. planetHP)
       	 	planetHPtextW.text = "Planet HP: " .. planetHP 
       	 	planetHPtextB.text = "Planet HP: " .. planetHP 
       	 	transition.to( planetHPcontainer, {time = 500, width = _X * (planetHP/allPlanetHP) } )

       	 	if planetHP <= 0 then
       	 		planet:removeSelf()
       	 		--field:removeSelf()
                planet = nil

               -- print("FIRST FUCK")

                --ship.bodyType = "dynamic"
                 local function onCollisionDelay()
    --change the body type
    ship.bodyType = "dynamic"
    ship:setLinearVelocity( math.random( -40, 40 ), math.random( -40, 40 ) )
    ship:applyTorque( math.random(-3, 3)/5 )

end
 
 if ship ~= nil then
timer.performWithDelay( 1, onCollisionDelay )
               end

       	 		GameOver()
       	 	end



         elseif ( obj1.myName == "asteroid" and obj2.myName == "planet" ) 
        then

        damage(obj1.x, obj1.y, -10)-----------------------------------------------
        audio.play(explousion)
        display.remove( obj1 )

            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1  ) then
                    
                    if asteroidsTable[i].touchJoint ~= nil and asteroidsTable[i] ~= nil then 
                        asteroidsTable[i].touchJoint = nil
                    end
                    table.remove( asteroidsTable, i )
                    break
                end
            end

            planetHP = planetHP - 10
           -- print("PLANET HP = " .. planetHP)
            planetHPtextW.text = "Planet HP: " .. planetHP 
            planetHPtextB.text = "Planet HP: " .. planetHP 
            transition.to( planetHPcontainer, {time = 500, width = _X * (planetHP/allPlanetHP) } )

            if planetHP <= 0 then
                planet:removeSelf()
               -- field:removeSelf()
                planet = nil

               local function onCollisionDelay()
    --change the body type
    ship.bodyType = "dynamic"
    ship:setLinearVelocity( math.random( -40, 40 ), math.random( -40, 40 ) )
    ship:applyTorque( math.random(-3, 3 )/5)
end
 if ship ~= nil then
timer.performWithDelay( 1, onCollisionDelay )
            end    

                GameOver()
            end

        

    	elseif ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
        then
            -- Remove both the laser and asteroid
            damage(obj1.x, obj1.y, "+10")
            
            display.remove( obj1 )
            display.remove( obj2 )
 
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
                    

                    if asteroidsTable[i].touchJoint ~= nil and asteroidsTable[i] ~= nil then 
                        asteroidsTable[i].touchJoint = nil
                    end

                    table.remove( asteroidsTable, i )
                    break
                end
            end

            score = score + 10
            scoreText.text = "Score: " .. score 



    	elseif  ( obj1.myName == "ship" and obj2.myName == "asteroid" ) then 
        
            -- Remove both the laser and asteroid
            damage(obj1.x, obj1.y, "-20")

            display.remove( obj2 )
           
        
 
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj2 ) then
                    
                    if asteroidsTable[i].touchJoint ~= nil and asteroidsTable[i] ~= nil then 
                        asteroidsTable[i].touchJoint = nil
                    end
                    table.remove( asteroidsTable, i )
                    break
                end
            end

                -- Update lives
                shipHP = shipHP - 20
                shipHPtextW.text = "Ship HP: " .. shipHP
                shipHPtextB.text = "Ship HP: " .. shipHP
                transition.to( shipHPcontainer, {time = 500, width = _X * (shipHP/allShipHP) } )
 
                if ( shipHP <= 0 ) then
                    ship:removeSelf( )
                    ship = nil
                    GameOver()
                    
                else
                   
               
            end



            elseif  ( obj1.myName == "asteroid" and obj2.myName == "ship" ) then --or
            
        
            -- Remove both the laser and asteroid
            damage(obj2.x, obj2.y, "-20")
            display.remove( obj1 )
           
           
 
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 ) then
                    
                    if asteroidsTable[i].touchJoint ~= nil and asteroidsTable[i] ~= nil then 
                        asteroidsTable[i].touchJoint = nil
                    end
                    table.remove( asteroidsTable, i )
                    break
                end
            end



 
                -- Update lives
                shipHP = shipHP - 20
                shipHPtextW.text = "Ship HP: " .. shipHP
                shipHPtextB.text = "Ship HP: " .. shipHP
                transition.to( shipHPcontainer, {time = 500, width = _X * (shipHP/allShipHP) } )
 
                if ( shipHP <= 0 ) then
                   ship:removeSelf( )
                   ship = nil
                    GameOver()
                    
                else
                   
               
            end



        end
          
    end

end






local function exitGame(  )
    composer.gotoScene( "menu", {time = 500, effect = "fade"} )
end



local function restartGame (event)
composer.gotoScene( "perehod", {time = 500, effect = "fade"} )

end
   
GameOver = function ( ... )
--timer.performWithDelay( 20, function ( ... )

    if score > record then 

        tt.rec = score
        LS.saveTable(tt, "rec.json")
        gameOverText2.text = "Score: " .. score .. " Record: " .. record .. "\n    NEW RECORD!"
   else
     gameOverText2.text = "Score: " .. score .. " Record: " .. record
    end
 

if planet == nil then
    ----------------------------------АШИБКА!!!!!!
    timer.performWithDelay( 1, function ( ... )
   -- for i = #asteroidsTable, 1, -1 do
        
        

   --     if asteroidsTable[i].touchJoint ~= nil and asteroidsTable[i].touchJoint ~= "nil" then
            --[[
            timer.performWithDelay( 20, function ( ... )]]
            
           
            
   --         asteroidsTable[i].touchJoint:removeSelf()
            
    --        asteroidsTable[i].touchJoint = nil

            --table.remove( asteroidsTable, i )
                -- body
           -- end)
      --  end
      print(#asteroidsTable)
      local i = #asteroidsTable
    while i > 0 do -- цикл от 10 до 1
        print("FUCK: " .. i  .. " " .. tostring(asteroidsTable[i].touchJoint))
        if asteroidsTable[i].touchJoint ~= nil then
            asteroidsTable[i].touchJoint:removeSelf()
        end
        i = i - 1
    end



        
   -- end
    end)
end


   
    fire = false
    Runtime:removeEventListener( "touch", onTouch )
    transition.to(UIGroup, {time = 500, alpha = 0} )
    transition.to(gameOverGroup, {time = 500, alpha = 1})


--end )
end




-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

    mainGroup = display.newGroup( )
    sceneGroup:insert(mainGroup)

    UIGroup = display.newGroup( )
    sceneGroup:insert(UIGroup)
    UIGroup:toFront( )

    gameOverGroup = display.newGroup( )
    sceneGroup:insert( gameOverGroup)
    gameOverGroup.alpha = 0


    tt = LS.loadTable("rec.json")


    local BG = display.newRect( sceneGroup, C_X, C_Y, display.actualContentWidth, display.actualContentHeight )
    BG.fill = 
    {
        type = "image", filename = "st.png"
    }
    BG.fill.scaleX = 0.2
    BG.fill.scaleY = 0.2
    
    BG:toBack( )


    
    record = tt.rec
    gameOverText = display.newText( gameOverGroup, "GAME OVER", C_X, C_Y - 250,  font, 80)
    gameOverText:setFillColor( 1,1,1 )
    gameOverText2 = display.newText( gameOverGroup, "Score: " .. score .. "Record: " .. record, C_X, gameOverText.y + gameOverText.height + 20,  font, 35)
    gameOverText2:setFillColor( 1,1,1 )

   restartBatonText = display.newText( gameOverGroup, "RESTART", C_X, C_Y + 150, font, 40 )
   restartBatonText:setFillColor( 1,1,1 )
   restartBatonText.fon1 = display.newRoundedRect(gameOverGroup, restartBatonText.x, restartBatonText.y, restartBatonText.width + 20, restartBatonText.height + 10, 10 )
   restartBatonText.fon1:setFillColor( 1,1,1 )
    restartBatonText.fon2 = display.newRoundedRect(gameOverGroup, restartBatonText.x, restartBatonText.y, restartBatonText.fon1.width - 10, restartBatonText.fon1.height - 10, 5 )
   restartBatonText:toFront( )
   restartBatonText.fon1:addEventListener( "tap", restartGame )

   exitBatonText = display.newText( gameOverGroup, "EXIT", C_X, C_Y + 250, font, 40 )
   exitBatonText:setFillColor( 1,1,1 )
   exitBatonText.fon1 = display.newRoundedRect(gameOverGroup, exitBatonText.x, exitBatonText.y, exitBatonText.width + 30, exitBatonText.height + 10, 10 )
   exitBatonText.fon1:setFillColor( 1,1,1 )
    exitBatonText.fon2 = display.newRoundedRect(gameOverGroup, exitBatonText.x, exitBatonText.y, exitBatonText.fon1.width - 10, exitBatonText.fon1.height - 10, 5 )
   exitBatonText:toFront( )
   exitBatonText.fon1:addEventListener( "tap", exitGame )


	ship = display.newPolygon(mainGroup, C_X, C_Y - 80,  {0,7, -5,0, 0,-7, -20,0})
	ship:setFillColor(0,0,0)
	ship.strokeWidth = 1
	ship.degStart = 0
	ship.rotation = 90
	physics.addBody(ship, "static", {radius = 5,density = 5})
	ship.myName = "ship"


	-- Code here runs when the scene is first created but has not yet appeared on screen
    planetHPcontainer = display.newContainer(UIGroup, display.actualContentWidth, 50 )
    planetHPcontainer.x, planetHPcontainer.y = C_X, display.safeScreenOriginY 


	planetHPline = display.newRect(UIGroup, C_X, planetHPcontainer.y, display.actualContentWidth, 25 )
	planetHPline.anchorY = 0
	planetHPline:setFillColor( 1, 1, 1 )
	planetHPtextW = display.newText(UIGroup, "Planet HP: " .. planetHP, C_X, planetHPcontainer.y, font, 20 )
	
	planetHPtextW.anchorY = 0
	planetHPtextW:setFillColor(1, 1, 1)
	planetHPtextB = display.newText(UIGroup, "Planet HP: " .. planetHP, C_X, planetHPcontainer.y, font, 20 )
	
	planetHPtextB.anchorY = 0

    planetHPcontainer:toFront()

	
	planetHPcontainer:insert(planetHPline, true)
	planetHPcontainer:insert( planetHPtextB, true )	



	

    shipHPcontainer = display.newContainer(UIGroup, display.actualContentWidth, 50 )
    shipHPcontainer.x, shipHPcontainer.y = C_X, planetHPcontainer.y + 25


	shipHPline = display.newRect(UIGroup, C_X, planetHPline.y , display.actualContentWidth, 25 )
    shipHPline.strokeWidth = 1
    shipHPline:setStrokeColor( 0,0,0 )
    shipHPline:setFillColor( 1, 1, 1 )
    shipHPline.anchorY = 0
    shipHPtextW = display.newText(UIGroup, "Ship HP: " .. allShipHP, C_X, shipHPcontainer.y , font, 20)
    shipHPtextW.anchorY = 0
    shipHPtextW:setFillColor(1, 1, 1)
    shipHPtextB = display.newText(UIGroup, "Ship HP: " .. allShipHP, C_X, shipHPcontainer.y , font, 20 )
    shipHPtextB.anchorY = 0

    shipHPcontainer:toFront( )
    
    --shipHPcontainer.anchorY=0
    shipHPcontainer:insert(shipHPline, true)
    shipHPcontainer:insert(shipHPtextB, true )



    scoreText = display.newText(UIGroup, "Score: " .. score, display.screenOriginX + display.actualContentWidth  , shipHPcontainer.y + 25, font, 20)
    scoreText.anchorY = 0
    scoreText.anchorX = 1
    scoreText:setFillColor(1, 1, 1)

    recordText = display.newText(UIGroup, "Record: " .. record, display.screenOriginX , shipHPcontainer.y + 25, font, 20)
    recordText.anchorY = 0
    recordText.anchorX = 0
    recordText:setFillColor(1, 1, 1)




	physics.pause()
    --[[
	planet = display.newCircle(mainGroup, C_X, C_Y, 60 )
	planet.strokeWidth = 1
]]

    planet = display.newSprite( planetSheet, something )
    mainGroup:insert(planet)
    planet:scale( 0.3, 0.3 )
    planet.x, planet. y = C_X , C_Y
    planet.width, planet.height = 125, 125
    planet:play()

	physics.addBody( planet, "static", {radius = planet.width * 0.5 })
	planet.myName = "planet"


	--field = display.newCircle(mainGroup, C_X, C_Y, fieldRadius )
	--field:setFillColor(1, 0.5, 0.5)
	--field.alpha = 0
 
-- Add physical body (sensor) to field
--physics.addBody( field, "static", { isSensor=true, radius=fieldRadius } )


--field.collision = collideWithField
--field:addEventListener( "collision" )


gameLoopTimer = timer.performWithDelay( 1500, gameLoop, 0 )


Runtime:addEventListener( "collision", onCollision )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        Runtime:addEventListener( "touch", onTouch )

		physics.start()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )
        --timer.cancel( uuu_suka )
        

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener( "touch", onTouch )
		
        physics.pause()

        for i = #asteroidsTable, 1, -1 do
            table.remove(asteroidsTable)
        end
        asteroidsTable = nil
       composer.removeScene( "game" )
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

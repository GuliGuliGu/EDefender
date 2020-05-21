local composer = require( "composer" )
require("DV")
local LS = require("loadsave")
 
system.setIdleTimer( false )

--чтоб не мылило пиксельное
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )

display.setDefault( "fillColor", {0,0,0})

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- Seed the random number generator
math.randomseed( os.time() )
 

 local function fileExists(file, dir)
    local path = system.pathForFile(file, dir or system.DocumentsDirectory)
    if not path then return false end
    local handle = io.open(path, 'r')
    if handle then
        handle:close()
        return true
    else
        return false
    end
end
-- Go to the menu screen
--composer.gotoScene( "scenes.splashScreen" )


--local memoryUsage = display.newText( "MEMORY = " .. system.getInfo( "appVersionString" ), 5, _Y, font, 15 )
 --memoryUsage.anchorX, memoryUsage.anchorY = 0,1
	
--local memUsage_str

function checkMemory()
  -- collectgarbage( "collect" )
  -- memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
  -- memoryUsage.text = memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) 
end
timer.performWithDelay( 1000, checkMemory, 0 )

local tt = {rec = 0}



if fileExists("rec.json", system.DocumentsDirectory) then
	print("ou my!")
else
	LS.saveTable(tt, "rec.json")
end



local buildNum = display.newText( "Build: " .. system.getInfo( "appVersionString" ), _X-5, _Y-5, font, 7 )
		buildNum.anchorX = 1
		buildNum.anchorY = 1
		buildNum:setFillColor(0.25, 0.25, 0.25)


audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )
--composer.gotoScene( "game" )
composer.isDebug = true
composer.gotoScene( "menu" )
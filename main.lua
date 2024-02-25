require("inc.run")  --* Change Love Standard Run Function
local keyboard      = require("inc.keyboard")
local gamepad       = require("inc.gamepad")
local mouse         = require("inc.mouse")
local displayTimer  = require("inc.displaytimer")
local audio         = require("inc.audio")
local editPNG    = require("src.editpng")
--local consolewindow = require("lib.consolewindow.consolewindow")
--local console       = require("lib.console.console")
require("lib.firstconsole.console")

DebugMe = false;

--! Load Function
function love.load()
    print("Loading...")
    --consolewindow.Load()                --* Load ConsoleWindow
end

--! Update Function
function love.update(dt)
    displayTimer.StartTimer()           --* DisplayTimer
    keyboard.Update(dt)                 --* Update Keyboard 
    gamepad.Update(dt)                  --* Update Gamepad
    mouse.Update(dt)                    --* Update Mouse
    audio.Update(dt)                    --* Update Audio
    editPNG.Update(dt)
    --consolewindow.Update(dt)            --* Update ConsoleWindow
    --console.Update(dt)                  --* Update Console
    --testTable.dt = dt
end

--! DrawScreen Function
function love.draw()
    editPNG.Draw()                   --* Draw Background
    --consolewindow.Draw()                --* Draw ConsoleWindow
    --console.Draw()                      --* Draw Console
    displayTimer.DisplayScreen()        --* DisplayTimer    
end

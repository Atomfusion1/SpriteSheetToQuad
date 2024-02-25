---@diagnostic disable: duplicate-set-field
-- Hook module for integrating custom console functionality into Love2D
local input = require("lib.firstconsole.src.input")
local parameters = require("lib.firstconsole.src.parameters")
local consoleSetup = require("lib.firstconsole.src.ui")
local loveIO = require("lib.firstconsole.src.io")

local hook = {}
local storage = {}

-- Overrides the default print function to include console output
storage.print = print
print = function(...)
    local args = {...}
    for i = 1, #args do
        if type(args[i]) == "string" then
            args[i] = args[i]:gsub("|c#%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        end
    end
    if not input.InputCaptured(...) then
        input.Print(...)
        storage.print(unpack(args))        
    end
end

-- Hooks into the Love2D main functions
function hook.hook()
    storage.draw = love.draw
    storage.update = love.update
    storage.mousePressed = love.mousepressed
    storage.mouseReleased = love.mousereleased
    storage.mouseMoved = love.mousemoved
    storage.keyPressed = love.keypressed
    storage.wheelMoved = love.wheelmoved

    love.draw = function() storage.draw() consoleSetup.draw() end
    love.update = function(dt) storage.update(dt) consoleSetup.update(dt) end
    love.mousepressed = function(x, y, button) storage.mousePressed(x, y, button) input.MousePressed(x, y, button) end
    love.mousereleased = function(x, y, button) storage.mouseReleased(x, y, button) input.MouseReleased(x, y, button) end
    love.mousemoved = function(x, y, dx, dy) storage.mouseMoved(x, y, dx, dy) input.MouseMoved(x, y, dx, dy) end
    love.keypressed = function(key) if parameters.keyThroughConsole == true then storage.keyPressed(key) end input.KeyPressed(key) end
    love.wheelmoved = function(x, y) storage.wheelMoved(x, y) input.WheelMoved(x, y) end
end

-- Restores the original Love2D main functions
function hook.unhook()
    love.draw = storage.draw
    love.update = storage.update
    love.mousepressed = storage.mousePressed
    love.mousereleased = storage.mouseReleased
    love.mousemoved = storage.mouseMoved
    love.wheelmoved = storage.wheelMoved
    love.keypressed = storage.keyPressed
end

-- Engages or disengages the console hook based on a toggle key
function EngageHook(key)
    if key == parameters.toggleKey then
        parameters._showConsole = not parameters._showConsole
        if parameters._showConsole then
            parameters._consoleInFocus = true
            hook.hook()
        else
            hook.unhook()
            loveIO.SaveIPairToFile("InputBuffer.txt", parameters.inputBuffer)
            loveIO.SaveIPairToFile("OutputBuffer.txt", parameters.outputBuffer)
            loveIO.SaveToFile("parameters.txt", parameters)
            _G.parameters = parameters
        end
    else
        if parameters._showConsole then input.InsertKey(key) end
        if parameters.keyThroughConsole and storage.input then storage.textInput(key) end
    end
end

-- Handles application quit event
function love.quit()
    loveIO.SaveIPairToFile("InputBuffer.txt", parameters.inputBuffer)
    loveIO.SaveIPairToFile("OutputBuffer.txt", parameters.outputBuffer)
    loveIO.SaveToFile("parameters.txt", parameters)
end

-- Startup: Load parameters and buffer content
storage.textInput = love.textinput
love.textinput = EngageHook
loveIO.LoadFromFile("parameters.txt", parameters)
loveIO.LoadIPairFromFile("InputBuffer.txt", parameters.inputBuffer)
loveIO.LoadIPairFromFile("OutputBuffer.txt", parameters.outputBuffer)

return hook

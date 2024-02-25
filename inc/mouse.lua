local inputKeys = require("inc.inputcontrol")

local mouse = {}

function mouse.Update(dt)
    if inputKeys.Mouse.update then
        inputKeys.Mouse.update(dt)
    end
end

--^ Any Functions Below are Internal Calls from Love2d *
--! Mouse Pressed (Internal Love2d Function)
function love.mousepressed(x, y, button, istouch, presses)
    if inputKeys.Mouse.mousePressed[button] then
        inputKeys.Mouse.mousePressed[button](x, y)
    end
end

--! Mouse Released (Internal Love2d Function)
function love.mousereleased(x, y, button, istouch)
    if inputKeys.Mouse.mouseReleased[button] then
        inputKeys.Mouse.mouseReleased[button](x, y)
    end
end

--! Mouse Moved (Internal Love2d Function)
function love.mousemoved(x, y, dx, dy)
    inputKeys.Mouse.mouseMoved(x, y, dx, dy)
end

--! Mouse Wheel Moved (Internal Love2d Function)
function love.wheelmoved(x, y)
    inputKeys.Mouse.wheelMoved(x, y)
end
--^ Any Functions above are Internal Calls from Love2d *

return mouse
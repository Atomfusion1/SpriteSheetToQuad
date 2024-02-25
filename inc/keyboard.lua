local inputKeys = require("inc.inputcontrol")


local keyboard = {}

--# Check for Keyboard Buttons that are down per update cycle
function UpdateKeyboard(dt)
    inputKeys.Keyboard.KeyIsDownStartCycle(dt)
    for key, value in pairs(inputKeys.Keyboard.keyIsDown) do
        if love.keyboard.isDown(key) then
            value(dt)
        end
    end
end

--# Update Keyboard
function keyboard.Update(dt)
    UpdateKeyboard(dt)     -- Check for Keyboard Buttons that are down per update cycle
end

--^ Any Functions Below are Internal Calls from Love2d *
--! Key is Pressed Check (Internal Love2d Function)
function love.keypressed(key)
    if inputKeys.Keyboard.keypressed[key] then
        inputKeys.Keyboard.keypressed[key]()
    end
end

--! Key is Released Check (Internal Love2d Function)
function love.keyreleased(key)
    if inputKeys.Keyboard.keyReleased[key] then
        inputKeys.Keyboard.keyReleased[key]()
    end
end
--^ Any Functions above are Internal Calls from Love2d *
return keyboard
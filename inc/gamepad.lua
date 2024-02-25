local inputKeys = require("inc.inputcontrol")

local gamepad = {}
---@diagnostic disable-next-line: duplicate-set-field
--# Setup Joystick Controller
local joysticks = love.joystick.getJoysticks()
local joystick1 = joysticks[1]
local joystick2 = joysticks[2]
if joysticks[1] then print("Joystick1 Detected and Setup Successfully") end
if joysticks[2] then print("Joystick2 Detected and Setup Successfully") end

--# Monitor Analog Sticks
local function MonitorAnalogSticks(dt, joystick, joystickName)
    -- L + R Triggers
    inputKeys.Joystick.MonitorAnalog.leftTrigger(dt, joystick:getGamepadAxis("triggerleft"), joystickName)
    inputKeys.Joystick.MonitorAnalog.rightTrigger(dt, joystick:getGamepadAxis("triggerright"), joystickName)    
    -- Analog Sticks 
    inputKeys.Joystick.MonitorAnalog.leftStick(dt, joystick:getGamepadAxis("leftx"), joystick:getGamepadAxis("lefty"), joystickName)
    inputKeys.Joystick.MonitorAnalog.rightStick(dt, joystick:getGamepadAxis("rightx"), joystick:getGamepadAxis("righty"), joystickName)
end

--# Check for joystick Buttons that are down per update cycle
function UpdateJoystick(dt)
    if joystick1 then
        for key, value in pairs(inputKeys.Keyboard.gamepadIsDown) do
            if joystick1:isGamepadDown(key) then
                value(joystick1)
            end
        end
        MonitorAnalogSticks(dt, joystick1, "Joystick1")     -- Monitor analog sticks for joystick1
    end
    if joystick2 then
        for key, value in pairs(inputKeys.Keyboard.gamepadIsDown) do
            if joystick2:isGamepadDown(key) then
                value()
            end
        end
        MonitorAnalogSticks(dt, joystick2, "Joystick2")     -- Monitor analog sticks for joystick2
    end
end

--# Update Joystick
function gamepad.Update(dt)
    UpdateJoystick(dt)     -- Check for joystick Buttons that are down per update cycle
end
--^ Any Functions Below are Internal Calls from Love2d *
--! Joystick is Pressed Check (Internal Love2d Function)
function love.gamepadpressed(joystick, button) -- Can Be gamepadreleased 
    if joystick1 then
        if inputKeys.Keyboard.gamepadIsPressed[button] then
            inputKeys.Keyboard.gamepadIsPressed[button](joystick)
        end
    end
end

--! Joystick is Pressed Check (Internal Love2d Function)
function love.gamepadreleased(joystick, button) -- Can Be gamepadreleased 
    if joystick1 then
        if inputKeys.Keyboard.gamepadIsReleased[button] then
            inputKeys.Keyboard.gamepadIsReleased[button]()
        end
    end
end
--^ Any Functions above are Internal Calls from Love2d *
return gamepad
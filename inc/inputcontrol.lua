local pngInput = require("src.pnginput")
local pngSave = require("src.pngsave")

-- escape counter for double tap escape
local escapeCounter = 0
local firstEscapeTime = nil

local input = {}
input.Version = "0.1.0"
input.Keyboard = {}
input.Joystick = {}
input.Mouse = {}

--! Keyboard Setup and Functions --------------------------------------------------------------
-- # Setup Key Pressed Values 
input.Keyboard.keypressed = {
    -- Escape Window with double tap of escape
    ["escape"] = function()
        if escapeCounter == 0 then
            firstEscapeTime = love.timer.getTime()
            escapeCounter = 1
        elseif escapeCounter == 1 then
            local currentTime = love.timer.getTime()
            if currentTime - firstEscapeTime <= 1.5 then
                love.event.quit()
            else
                escapeCounter = 0
            end
        end
    end,
    ["r"] = function() --@ Save Frame
        local x, y = love.mouse.getPosition() -- Get the current mouse position
        --@ Save the current selection as a new Quad in frame
        table.insert(pngInput.frames, love.graphics.newQuad(pngInput.selectionOffsetX, pngInput.selectionOffsetY, pngInput.selectionWidth, pngInput.selectionHeight, pngInput.pngWidth, pngInput.pngHeight))
        table.insert(pngInput.offsetOfFrames, {offsetX = 0, offsetY = 0})
        pngInput.currentFrame = #pngInput.frames
        print("Added frame " .. pngInput.currentFrame)
    end,
    ['q'] = function() --@ Delete Frame
        -- Backspace key logic for deleting the current frame
        if #pngInput.frames > 0 and pngInput.currentFrame >= 1 then
            print("Backspace key pressed, removing frame " .. pngInput.currentFrame)
            table.remove(pngInput.frames, pngInput.currentFrame)  -- Remove the current frame
            pngInput.currentFrame = math.max(1, pngInput.currentFrame - 1)  -- Adjust currentFrame pointer, so it does not go out of bounds
        end
    end,
    ["s"] = function()
        pngSave.SaveNow("saveframes")
        print("s")
    end,
    ["c"] = function() --@ Clear all Frames and reset currentFrame to 1
        pngInput.frames = {}
        pngInput.currentFrame = 1
    end,
    ["e"] = function() --@ replace/edit current selected frame
        if #pngInput.frames > 0 then
            pngInput.frames[pngInput.currentFrame] = love.graphics.newQuad(pngInput.selectionOffsetX, pngInput.selectionOffsetY, pngInput.selectionWidth, pngInput.selectionHeight, pngInput.pngWidth, pngInput.pngHeight)
        end
    end,
    ["space"] = function() pngInput.isAnimationPlaying = not pngInput.isAnimationPlaying end, --@ enable animation 
    ["`"] = function()
        --print("This Can Be used for Extra information or Popup window")
        --print("There is 16,666 us per frame at 60 fps love needs 500us")
    end,
    ["up"] = function() 
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            pngInput.selectionOffsetY = pngInput.selectionOffsetY - pngInput.shiftMoveAmount
        elseif love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then

        else
            pngInput.selectionOffsetY = pngInput.selectionOffsetY - pngInput.moveAmount
        end
    end,
    ["down"] = function() 
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            pngInput.selectionOffsetY = pngInput.selectionOffsetY + pngInput.shiftMoveAmount
        elseif love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then

        else
            pngInput.selectionOffsetY = pngInput.selectionOffsetY + pngInput.moveAmount
        end
    end,
    ["left"] = function() 
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            pngInput.selectionOffsetX = pngInput.selectionOffsetX - pngInput.shiftMoveAmount
        elseif love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
            pngInput.offsetOfFrames[pngInput.currentFrame].offsetX = pngInput.offsetOfFrames[pngInput.currentFrame].offsetX - 1
        else
            pngInput.selectionOffsetX = pngInput.selectionOffsetX - pngInput.moveAmount
        end
    end,
    ["right"] = function()
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            pngInput.selectionOffsetX = pngInput.selectionOffsetX + pngInput.shiftMoveAmount
        elseif love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
            pngInput.offsetOfFrames[pngInput.currentFrame].offsetX = pngInput.offsetOfFrames[pngInput.currentFrame].offsetX + 1
        else
            pngInput.selectionOffsetX = pngInput.selectionOffsetX + pngInput.moveAmount
        end
    end,
    ["kp+"] = function()
        if pngInput.currentFrame < #pngInput.frames then
            pngInput.currentFrame = pngInput.currentFrame + 1
            local frameX, frameY, frameWidth, frameHeight = pngInput.frames[pngInput.currentFrame]:getViewport()
            pngInput.selectionOffsetX = frameX
            pngInput.selectionOffsetY = frameY
            pngInput.selectionWidth = frameWidth
            pngInput.selectionHeight = frameHeight
        end
    end,
    ["kp-"] = function()
        if pngInput.currentFrame > 1 then
            pngInput.currentFrame = pngInput.currentFrame - 1
            local frameX, frameY, frameWidth, frameHeight = pngInput.frames[pngInput.currentFrame]:getViewport()
            pngInput.selectionOffsetX = frameX
            pngInput.selectionOffsetY = frameY
            pngInput.selectionWidth = frameWidth
            pngInput.selectionHeight = frameHeight
        end
    end,
    ["p"] = function() pngInput.isPersistantImage = not pngInput.isPersistantImage end,
}

--# Setup Keyboard Released Values
input.Keyboard.keyReleased = {
    ["f"]       = function() print("f released") end,
    ["g"]       = function() print("g released") end,
}

--@ Run Before Key Is Down (used to reset values)
input.Keyboard.KeyIsDownStartCycle = function(dt)

end


-- # Setup Checks for If Key is Down
input.Keyboard.keyIsDown = {
    ["left"] = function()
        --print("left")
    end,
    ["right"] = function()
        --print("right")
    end,
    ["up"] = function()
        --print("up")
    end,
    ["down"] = function()
        --print("down")
    end,
    ["5"]       = function(dt) print("5") end,
    ["lshift"]  = function(dt)  end,
    ["z"]       = function(dt) print("z") end,
}

--! Joystick Setup and Functions --------------------------------------------------------------
--# Setup Gamepad Pressed Values
input.Keyboard.gamepadIsPressed = {
    ["a"] = function()
        print("a")
    end,
    ["b"] = function(joystick)
        print("b")
    end,
    ["y"] = function() print("pressed Y")  end,
    ["x"] = function() print("pressed X")  end,
}

input.Keyboard.gamepadIsReleased = {
    ["leftstick"] = function() print("left stick released")  end,  -- Handling left stick click
    ["rightstick"] = function() print("right stick released")  end,  -- Handling right stick click    
}

--# Setup Gamepad Held Down Values
input.Keyboard.gamepadIsDown = {
    ["dpup"] = function() print("dpup") end,
    ["dpdown"] = function() print("dpdown") end,
    ["dpleft"] = function(joystick)
        print("dpleft")
    end,
    ["dpright"] = function(joystick)
        print("dpright")
    end,
    ["back"]            = function() print("back")  end,
    ["start"]           = function() print("start") end,
    ["rightshoulder"]   = function() print("shoulder R")  end,
    ["leftshoulder"]    = function() print("shoulder L")  end,
}

--# Analog Stick and Trigger Monitoring
input.Joystick.MonitorAnalog = {
    leftTrigger = function(dt, value, joystickName)
        if value ~= 0 then
            print(string.format("%s Left Trigger: %.3f", joystickName, value))
        end
    end,
    rightTrigger = function(dt, value, joystickName)
        if value ~= 0 then
            print(string.format("%s Right Trigger: %.3f", joystickName, value))
        end
    end,
    leftStick = function(dt, x, y, joystickName)
        if (x > 0.1 or x < -0.1) or (y > 0.1 or y < -0.1) then
            print(string.format("%s Left Stick: %.3f, %.3f", joystickName, x, y))
    end
    end,
    rightStick = function(dt, x, y, joystickName)
        if (x > 0.1 or x < -0.1) or (y > 0.1 or y < -0.1) then
            print(string.format("%s Right Stick: %.3f, %.3f", joystickName, x, y))
        end
    end,
}

--! Mouse Setup and Functions --------------------------------------------------------------
--# Mouse Button Pressed Values
input.Mouse.update = function(dt)
    if love.mouse.isDown(1) then
    end
end

input.Mouse.mousePressed = {
    [1] = function(x, y)
        if x > pngInput.pngWidth + 40 or y > pngInput.pngHeight + 40 or x < 40 or y < 40 then
            print("Mouse is outside the image")
            return
        end
        --! Check if the mouse is inside the selection box
        if x >= pngInput.selectionOffsetX + 40 and x <= pngInput.selectionOffsetX + 40 + pngInput.selectionWidth and
            y >= pngInput.selectionOffsetY + 40 and y <= pngInput.selectionOffsetY + 40 + pngInput.selectionHeight then
            --@ The mouse is inside the box prepare to drag
            pngInput.dragOffsetX = x - (pngInput.selectionOffsetX + 40)     --# Note: offsetX and offsetY store how far inside the box the click occurred
            pngInput.dragOffsetY = y - (pngInput.selectionOffsetY + 40)
            pngInput.dragging = true
            pngInput.expand = false
        else
            --@ The mouse click occurred outside the box; start a new selection
            pngInput.selectionOffsetX = x - 40
            pngInput.selectionOffsetY = y - 40
            pngInput.dragging = false
            pngInput.expand = true
        end
    end,
    --[2] = function(x, y) print("Right Mouse Button Pressed at x:" .. x .. ", y:" .. y) end,
}

--# Mouse Button Released Values
input.Mouse.mouseReleased = {
    [1] = function(x, y)
        --@ Reset Functions when mouse is released
        pngInput.dragging = false
        pngInput.expand = false
    end,
    --[1] = function(x, y) print("Left Mouse Button Released at x:" .. x .. ", y:" .. y) end,
    --[2] = function(x, y) print("Right Mouse Button Released at x:" .. x .. ", y:" .. y) end,
}

--# Mouse Moved
input.Mouse.mouseMoved = function(x, y, dx, dy)
    if love.mouse.isDown(1) then    -- You can also handle delta (dx, dy) here if you need
        --@ Update the position of the box as the mouse moves
        if pngInput.dragging then
            local x, y = love.mouse.getPosition() -- Get the current mouse position
            pngInput.selectionOffsetX = x - 40 - pngInput.dragOffsetX
            --# if Shift held then ignore Y Changes
            if not love.keyboard.isDown("lshift") and not love.keyboard.isDown("rshift") then
                pngInput.selectionOffsetY = y - 40 - pngInput.dragOffsetY
            end
        end
        --@ Update the expansion of the box as the mouse moves
        if pngInput.expand then
            local x, y = love.mouse.getPosition() -- Get the current mouse position
            --# Update the size of the selection if we are not dragging
            if x > pngInput.selectionOffsetX + 40 and y > pngInput.selectionOffsetY + 40 then
                pngInput.selectionWidth = (x - 40) - pngInput.selectionOffsetX
                pngInput.selectionHeight = (y - 40) - pngInput.selectionOffsetY
            end
        end
    end
end

--# Mouse Wheel Moved
input.Mouse.wheelMoved = function(x, y)
    --print("Mouse Wheel Moved with x:" .. x .. ", y:" .. y)
end

return input
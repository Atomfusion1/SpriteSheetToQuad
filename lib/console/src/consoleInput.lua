local parameters = require("lib.console.src.paramaters")

local enableDrag1 = false
local enableDrag2 = false
local enableDrag3 = false
local enableDrag4 = false
local isDownLock = false

local consoleInput = {}

function consoleInput.Update(dt)


end

function consoleInput.consoleInput()
    -- check if keyboard is pressed and wait till release to allow another press
    if love.keyboard.isDown(parameters.console.shortcutKey) and not isDownLock then
        parameters.console.visible = not parameters.console.visible
        isDownLock = true
    elseif isDownLock and not love.keyboard.isDown(parameters.console.shortcutKey) then
        isDownLock = false
    end
    if not parameters.console.visible then return end
    if love.mouse.isDown(1) then
        local lineOffset = 5
        local x, y = love.mouse.getPosition()
        if enableDrag1 or enableDrag2 or enableDrag3 or enableDrag4 then
            -- Setup Cursor 
            if enableDrag1 and enableDrag3 or enableDrag2 and enableDrag4 then love.mouse.setCursor(love.mouse.getSystemCursor("sizenwse"))
            elseif enableDrag1 and enableDrag4 or enableDrag2 and enableDrag3 then love.mouse.setCursor(love.mouse.getSystemCursor("sizenesw"))
            elseif enableDrag1 or enableDrag2 then love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))
            elseif enableDrag3 or enableDrag4 then love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))
            end
            -- Update Edge Locations
            if enableDrag1 then
                parameters.console.width = parameters.console.width + parameters.console.offsetX - x
                parameters.console.offsetX = x
            end
            if enableDrag2 then
                parameters.console.width = x - parameters.console.offsetX
            end
            if enableDrag3 then
                parameters.console.height = parameters.console.height + parameters.console.offsetY - y
                parameters.console.offsetY = y
            end
            if enableDrag4 then
                parameters.console.height = y - parameters.console.offsetY
            end
        else
            if x > parameters.console.offsetX - lineOffset and x < parameters.console.offsetX + lineOffset then
                enableDrag1 = true
            end
            if x > parameters.console.offsetX + parameters.console.width - lineOffset and x < parameters.console.offsetX + parameters.console.width + lineOffset then
                enableDrag2 = true
            end
            if y > parameters.console.offsetY - lineOffset and y < parameters.console.offsetY + lineOffset then
                enableDrag3 = true
            end
            if y > parameters.console.offsetY + parameters.console.height - lineOffset and y < parameters.console.offsetY + parameters.console.height + lineOffset then
                enableDrag4 = true
            end
        end
    else
        enableDrag1 = false
        enableDrag2 = false
        enableDrag3 = false
        enableDrag4 = false
        love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
    end

    -- Check if unactive window when clicking outside of it 
    if love.mouse.isDown(1) and not enableDrag1 and not enableDrag2 and not enableDrag3 and not enableDrag4 then
        local x, y = love.mouse.getPosition()
        if x < parameters.console.offsetX or x > parameters.console.offsetX + parameters.console.width or y < parameters.console.offsetY or y > parameters.console.offsetY + parameters.console.height then
            parameters.console.active = false
            print("unactive")
        else
            parameters.console.active = true
            print("active")
        end
    end
end

return consoleInput
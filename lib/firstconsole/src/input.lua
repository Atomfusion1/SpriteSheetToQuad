-- Input handling for the console
local parameters = require("lib.firstconsole.src.parameters")

local input = {}
local inputBuffer = 0

function input.MoveCursorLeft()
    if parameters._cursorPosition > 1 then
        parameters._cursorPosition = parameters._cursorPosition - 1
    end
end

function input.MoveCursorRight()
    if parameters._cursorPosition <= #parameters._CurrentInput then
        parameters._cursorPosition = parameters._cursorPosition + 1
    end
end

-- Stacks the output buffer with support for multiline strings
function input.addToOutputBuffer(inputString)
    local maxBufferEntries = parameters.maxBufferEntries

    if inputString ~= "* " then
        -- Split inputString by newlines
        local lines = {}
        for line in inputString:gmatch("[^\n]+") do
            table.insert(lines, line)
        end

        for _, line in ipairs(lines) do
            -- Only trim trailing whitespace
            line = line:gsub("[%s]+$", "")

            local lastEntry = parameters.outputBuffer[#parameters.outputBuffer]
            if lastEntry then
                -- Extract the message and count from the last entry if it has a count
                local message, count = lastEntry:match("^(.-)%s*%((%d+)%)$")
                count = count and tonumber(count) or 1
                if not message then
                    message = lastEntry
                end

                -- Check if the trimmed line matches the message of the last entry
                if message == line then
                    -- Update the last entry with the new count
                    parameters.outputBuffer[#parameters.outputBuffer] = line .. " (" .. (count + 1) .. ")"
                else
                    -- Insert the new line and reset count
                    table.insert(parameters.outputBuffer, line)
                end
            else
                -- Buffer is empty or no match with the last entry, just insert the line
                table.insert(parameters.outputBuffer, line)
            end

            -- Ensure buffer does not exceed maxBufferEntries
            while #parameters.outputBuffer > maxBufferEntries do
                table.remove(parameters.outputBuffer, 1)
            end
        end
    end
end


function input.AddToInputBuffer(inputString)
    local maxBufferEntries = parameters.maxBufferEntries
    if inputString ~= "" then
        -- Check if the last entry in the buffer is the same as the input
        if parameters.inputBuffer[#parameters.inputBuffer] ~= inputString then
            table.insert(parameters.inputBuffer, inputString)
            -- Remove the oldest entries if the buffer exceeds the maximum size
            while #parameters.inputBuffer > maxBufferEntries do
                table.remove(parameters.inputBuffer, 1)
            end
        end
    end
end


function input.ExecuteCurrentInput()
    if parameters._CurrentInput ~= "" and parameters._CurrentInput:sub(1, 1) ~= "$" then
        local func, err = loadstring(parameters._CurrentInput)
        if func then
            local success, executionResult = pcall(func)
            if not success then
                print("Error executing command: " .. executionResult)
            end
        else
            print("Error loading command: " .. err)
        end
    end
    if parameters._CurrentInput:sub(1, 4) == "$clr" then
        input.ClearBuffer()
    end
    if parameters._CurrentInput:sub(1, 5) == "$help" then
        input.HelpMSG()
    end
    parameters._CurrentInput = ""
end

local function CursorPositionCheck()
    if parameters._cursorPosition > #parameters._CurrentInput + 1 then
        parameters._cursorPosition = #parameters._CurrentInput + 1
    end
end

local function modifyCurrentInput(modificationFunc)
    parameters._CurrentInput, parameters._cursorPosition = modificationFunc(parameters._CurrentInput, parameters._cursorPosition)
end

function input.KeyPressed(key)
    if not parameters._consoleInFocus then return end
    CursorPositionCheck()
    if key == "tab" then
        if parameters.autocomplete.proposals[parameters.autocomplete.proposalIndex] then parameters._CurrentInput = parameters._CurrentInput..parameters.autocomplete.proposals[parameters.autocomplete.proposalIndex] end
        parameters._cursorPosition = #parameters._CurrentInput + 1
    end
    if key == "return" or key == "kpenter" then
        parameters._scrollPosition = 0
        input.AddToInputBuffer(parameters._CurrentInput)
        input.addToOutputBuffer("* " .. parameters._CurrentInput)
        input.ExecuteCurrentInput()
        inputBuffer = 0
    elseif key == "backspace" then
        modifyCurrentInput(function(input, pos)
            if pos > 1 then
                return input:sub(1, pos - 2) .. input:sub(pos), pos - 1
            end
            return input, pos
        end)
    elseif key == "delete" then
        modifyCurrentInput(function(input, pos)
            return input:sub(1, pos - 1) .. input:sub(pos + 1), pos
        end)
    elseif key == "c" and love.keyboard.isDown("lctrl") then
        love.system.setClipboardText(parameters._CurrentInput)
    elseif key == "v" and love.keyboard.isDown("lctrl") then
        local clipboardText = love.system.getClipboardText() or ""
        modifyCurrentInput(function(input, pos)
            return input:sub(1, pos - 1) .. clipboardText .. input:sub(pos), pos + #clipboardText
        end)
    elseif key == "up" or key == "down" then
        local delta = key == "up" and 1 or -1
        if inputBuffer + delta >= 0 and inputBuffer + delta <= #parameters.inputBuffer then
            inputBuffer = inputBuffer + delta
            parameters._CurrentInput = parameters.inputBuffer[#parameters.inputBuffer - inputBuffer + 1] or ""
            parameters._cursorPosition = #parameters._CurrentInput + 1
        end
    elseif key == "left" then
        input.MoveCursorLeft()
    elseif key == "right" then
        input.MoveCursorRight()
    end
end

function input.InsertKey(key)
    if parameters._consoleInFocus then
        parameters._CurrentInput = parameters._CurrentInput:sub(1, parameters._cursorPosition - 1) .. key .. parameters._CurrentInput:sub(parameters._cursorPosition)
        parameters._cursorPosition = parameters._cursorPosition + 1
    end
end

function input.Print(...)
    local args = {...}
    local inputString = table.concat(args, " ") 
    input.addToOutputBuffer(inputString)
end

function input.SetCursorPosition(mouseX, textStartX)
    local font = love.graphics.getFont()
    local promptWidth = font:getWidth("> ") 
    local cumulativeWidth = textStartX + promptWidth 
    for i = 1, #parameters._CurrentInput do
        local charWidth = font:getWidth(parameters._CurrentInput:sub(i, i))
        if mouseX < cumulativeWidth + charWidth / 2 then
            parameters._cursorPosition = i
            return
        end
        cumulativeWidth = cumulativeWidth + charWidth
    end
    parameters._cursorPosition = #parameters._CurrentInput + 1
end

function input.MousePressed(x, y, button)
    if button == 1 then
        local textY = parameters.consoleEnd 
        if y >= textY and y <= textY + love.graphics.getFont():getHeight() then
            input.SetCursorPosition(x, 10)
        end
        if y >= parameters.consoleEnd + 15 and y <= parameters.consoleEnd + 25 then
            parameters._isResizingBottom = true
        end
        if y >= parameters.consoleStart and y <= parameters.consoleStart + 15 then
            parameters._isResizingTop = true
        end
        if y >= parameters.consoleStart and y <= parameters.consoleEnd + 25 then
            parameters._consoleInFocus = true
        else
            parameters._consoleInFocus = false
        end
    end
end

function input.MouseReleased(x, y, button)
    if button == 1 then
        parameters._isResizingBottom = false
        parameters._isResizingTop = false
    end
end

function input.MouseMoved(x, y, dx, dy)
    if parameters._isResizingBottom then
        parameters.consoleEnd = y - 20
    end
    if parameters._isResizingTop then
        parameters.consoleStart = y
    end
end

function input.WheelMoved(x, y)
    if parameters._consoleInFocus then
        if y > 0 then  
            parameters._scrollPosition = parameters._scrollPosition + y
        elseif y < 0 then 
            if parameters._scrollPosition > 0 then
                parameters._scrollPosition = parameters._scrollPosition + y
            end
        end
    end
end

function input.InputCaptured(...)
    local args = {...}
    local inputString = table.concat(args, " ") 
    if inputString == "$clr" then
        input.ClearBuffer()
        return true
    end
end

function input.HelpMSG()
    CPrint("#CA4B34", "FirstConsole Help:")
    CPrint("#00ff00", " $clr - Clears the buffer")
    CPrint("#00ff00", " Warn(\"Text\")")
    CPrint("#00ff00", " Err(\"Text\")")
    CPrint("#00ff00", " Info(\"Text\")")
    CPrint("#00ff00", " Cprint(\"#RRGGBBAA\",\"Text\")")
    CPrint("#00ff00", " TPrint(table, #depth)")
    CPrint("#00ff00", " SeeGlobalVar(#depth)")
    CPrint("#00ff00", " PrintDirectory(\"folder\")")
    CPrint("#00ff00", " AddMonitor(\"name\", function() return value end, \"#RRGGBBAA\")")
end

function input.ClearBuffer()
    parameters.outputBuffer = {}
    print("Buffer cleared.")
end

return input

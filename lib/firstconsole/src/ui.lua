-- Console setup for the custom console in Love2D
parameters = require("lib.firstconsole.src.parameters")

require("lib.firstconsole.src.testing")
local input = require("lib.firstconsole.src.input")

local consoleUI = {}

-- Cursor visibility and timer for blinking effect
local cursorVisible = true
local cursorTimer = 0
local leftkey = 0
local rightkey = 0
local backspacekey = 0
local deletekey = 0

-- Draws the console background
local function DrawBackground()
    local backgroundColor = parameters.toRGBTable(parameters.backgroundColor)
    local typingBarColor = parameters.toRGBTable(parameters.typingBarColor)
    local dragBarColor = parameters.toRGBTable(parameters.dragBarColor)
    love.graphics.setColor(backgroundColor)
    love.graphics.rectangle("fill", parameters.dragBarYOffset, parameters.consoleStart, parameters.dragBarYOffset + parameters.dragBarYLength, parameters.consoleEnd - parameters.consoleStart)
    love.graphics.setColor(typingBarColor)
    love.graphics.rectangle("fill", parameters.dragBarYOffset, parameters.consoleEnd, parameters.dragBarYOffset + parameters.dragBarYLength, 15)
    love.graphics.setColor(dragBarColor)
    love.graphics.rectangle("fill", parameters.dragBarYOffset, parameters.consoleEnd + parameters.dragBarXOffset, parameters.dragBarYOffset + parameters.dragBarYLength, parameters.dragBarXLength)
    love.graphics.rectangle("fill", parameters.dragBarYOffset, parameters.consoleStart, parameters.dragBarYOffset + parameters.dragBarYLength, parameters.dragBarXLength)
    love.graphics.rectangle("fill", parameters.dragBarYOffset, parameters.consoleStart + 5, 5, parameters.consoleEnd - parameters.consoleStart + 10)
    love.graphics.rectangle("fill", 2*parameters.dragBarYOffset + parameters.dragBarYLength - 5, parameters.consoleStart + 5, 5, parameters.consoleEnd - parameters.consoleStart + 10)
    
end

-- Draws the cursor in the console
local function Cursor()
    local font = love.graphics.getFont()
    local cursorX = 10
    local cursorY = parameters.consoleEnd
    local cursorWidth = 2
    local cursorHeight = 16
    local cursorColor = parameters.toRGBTable(parameters.cursorLineColor)
    local inputTextColor = parameters.toRGBTable(parameters.inputTextColor)
    local textBeforeCursor = parameters._CurrentInput:sub(1, parameters._cursorPosition - 1)
    local textWidth = font:getWidth("> " .. textBeforeCursor)
    love.graphics.setColor(inputTextColor)
    love.graphics.print("   "..parameters._CurrentInput, parameters.dragBarYOffset + cursorX, cursorY)
    love.graphics.setColor(cursorColor)
    love.graphics.print("> ", parameters.dragBarYOffset + cursorX, cursorY)
    if cursorVisible then
        love.graphics.setColor(cursorColor)
        love.graphics.rectangle("fill", parameters.dragBarYOffset + cursorX + textWidth-3, cursorY, cursorWidth, cursorHeight)
    end
end

-- Parses colored text for display in the console
local function parseColoredText(text)
    if type(text) ~= "string" then
        return {}
    end
    local segments = {}
    local pattern = "|c#(%x%x%x%x%x%x%x%x)(.-)|r"
    local lastEnd = 1
    for color, txt in text:gmatch(pattern) do
        local segmentStart, segmentEnd, capColor, capTxt = text:find("(%|c#%x%x%x%x%x%x%x%x)(.-)(%|r)", lastEnd)
        if not segmentStart then break end
        if segmentStart > lastEnd then
            table.insert(segments, {text = text:sub(lastEnd, segmentStart - 1), color = nil})
        end
        table.insert(segments, {text = capTxt, color = color})
        lastEnd = segmentEnd + 1
    end
    if lastEnd <= #text then
        table.insert(segments, {text = text:sub(lastEnd), color = nil})
    end
    return segments
end

-- Displays the console buffer
local function DisplayBuffer()
    local font = love.graphics.getFont()
    local bufferX = 10
    local bufferStartY = parameters.consoleEnd - 20
    local lineHeight = font:getHeight() + 4
    local maxLines = math.floor(bufferStartY / lineHeight)
    local startLine = math.max(1, #parameters.outputBuffer - maxLines - parameters._scrollPosition + 1)
    local endLine = math.max(1, #parameters.outputBuffer - parameters._scrollPosition)
    for i = endLine, startLine, -1 do
        local text = parameters.outputBuffer[i]
        if text then
            local segments = parseColoredText(text)
            local x = bufferX
            local y = bufferStartY - (lineHeight * (endLine - i))
            for _, segment in ipairs(segments) do
                if segment.text and type(segment.text) == "string" then
                    local color = segment.color and parameters.toRGBTable(segment.color) or parameters.toRGBTable(parameters.bufferTextColor)
                    love.graphics.setColor(color)
                    if y > parameters.consoleStart then love.graphics.print(segment.text, parameters.dragBarYOffset + x, y) end
                    x = x + font:getWidth(segment.text)
                end
            end
        end
    end
end

local function DisplayAutoComplete()
    local autocomplete = parameters.autocomplete
    local font = love.graphics.getFont()
    local cursorX = 10
    local cursorY = parameters.consoleEnd
    local textBeforeCursor = parameters._CurrentInput:sub(1, parameters._cursorPosition - 1)
    local textWidth = font:getWidth("> " .. textBeforeCursor)
    if #autocomplete.proposals > 0 then
        love.graphics.setColor(parameters.toRGBTable(parameters.autocomplete.proposalColor))
        love.graphics.print(autocomplete.proposals[autocomplete.proposalIndex], parameters.dragBarYOffset + cursorX + textWidth, cursorY)
        love.graphics.setColor(1,1,1,1)
    end
end

local function DisplayWatchList()
    local font = love.graphics.getFont()
    local watchListX = parameters.watchListXOffset
    local watchListY = parameters.consoleStart + parameters.watchListYOffset
    local lineHeight = font:getHeight() + 4

    for name, details in pairs(parameters.watchList) do
        local value = type(details.valueOrFunction) == "function" and details.valueOrFunction() or details.valueOrFunction
        local text = name .. ": " .. tostring(value)
        local color = parameters.toRGBTable(details.hexColor or "#FFFFFF")
        love.graphics.setColor(color)
        love.graphics.print(text, watchListX, watchListY)
        watchListY = watchListY + lineHeight
    end
end



-- Main draw function for the console
function consoleUI.draw()
    DrawBackground()
    DisplayBuffer()
    DisplayWatchList()  -- Add this line to draw the watch list
    if parameters._consoleInFocus then
        Cursor()
        DisplayAutoComplete()
    end
    love.graphics.setColor(1, 1, 1, 1)
end

-- Updates mouse state for resizing and cursor changes
local function UpdateMouseState()
    local x, y = love.mouse.getPosition()
    local topEdge = parameters.consoleStart
    local bottom_edge = parameters.consoleEnd
    -- top and bottom bar 
    if y >= bottom_edge + parameters.dragBarXOffset and y <= bottom_edge + parameters.dragBarXOffset + parameters.dragBarXLength then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))
    elseif y >= topEdge and y <= topEdge + parameters.dragBarXLength  then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))
    else
        love.mouse.setCursor()
    end
    -- left and right bar 
    if x >= parameters.dragBarYOffset - 5 and x <= parameters.dragBarYOffset + 5 then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))
    elseif x >= 2 * parameters.dragBarYOffset + parameters.dragBarYLength and x <= 2 * parameters.dragBarYOffset + parameters.dragBarYLength + 5 then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))
    else
        love.mouse.setCursor()
    end
end

-- Updates the cursor blink effect
local function UpdateCursor(dt)
    cursorTimer = cursorTimer + dt
    if cursorTimer >= parameters.cursorBlinkDuration then
        cursorVisible = not cursorVisible
        cursorTimer = 0
    end
end


--watch for "([ for autocomplete])"
local function FinishAutocomplete(inputString, len)
    -- Determine the context of the input (e.g., inside a string or parentheses)
    local inString = false
    local inParentheses = 0
    local inSquareBrackets = 0
    local quoteType = nil
    for i = 1, len do
        local char = inputString:sub(i, i)
        -- Handle string context
        if (char == "\"" or char == "'") and (i == 1 or inputString:sub(i-1, i-1) ~= "\\") then
            if inString and char == quoteType then
                inString = false
                quoteType = nil
            elseif not inString then
                inString = true
                quoteType = char
            end
        end
        -- Handle parentheses and square brackets
        if not inString then
            if char == "(" then
                inParentheses = inParentheses + 1
            elseif char == ")" and inParentheses > 0 then
                inParentheses = inParentheses - 1
            elseif char == "[" then
                inSquareBrackets = inSquareBrackets + 1
            elseif char == "]" and inSquareBrackets > 0 then
                inSquareBrackets = inSquareBrackets - 1
            end
        end
    end

    -- Add closing characters to proposals based on context
    local holder = ""
    if inString then
        holder = holder .. quoteType
    end
    if inParentheses > 0 then
        holder = holder .. ")"
    end
    if inSquareBrackets > 0 then
        holder = holder ..  "]"
    end
    return holder
end

    -- Function to extract the relevant segments for autocompletion
    local function extractSegments(str)
        local pattern = '["\'%(%[%].]'
        local lastPosition = 0
        local secondLastPosition = 0
        local inQuote = false
        local quoteChar = ''

        for position, char in str:gmatch('()(' .. pattern .. ')') do
            if char == '"' or char == "'" then
                if not inQuote then
                    inQuote = true
                    quoteChar = char
                elseif inQuote and char == quoteChar then
                    inQuote = false
                end
            elseif not inQuote then
                secondLastPosition = lastPosition
                lastPosition = position
            end
        end
        local secondLastSegment = ""
        if lastPosition > 0 then secondLastSegment = str:sub(secondLastPosition + 1, lastPosition - 1) end
        local lastSegment = str:sub(lastPosition + 1)
        return secondLastSegment, lastSegment
    end

local function UpdateAutocomplete()
    local inputString = parameters._CurrentInput
    local len = #inputString
    local proposals = {}

    local secondLastSegment, lastSegment = extractSegments(inputString)
    local segmentLen = #lastSegment
    -- Finish autocomplete for closing characters
    local holder = FinishAutocomplete(inputString, len)

    local passingTable = _G
    if _G[secondLastSegment] and secondLastSegment:len() > 0 then
        passingTable = _G[secondLastSegment]
    end
    if type(passingTable) ~= 'table' then passingTable = _G end
        for k, v in pairs(passingTable) do
            if type(k) == 'string' and k:match("^[_a-zA-Z][_a-zA-Z0-9]*$") then
                if k:sub(1, segmentLen) == lastSegment then
                    table.insert(proposals, k:sub(segmentLen + 1, #k)..holder)
                end
            end
        end
        for _, kw in ipairs(parameters.autocomplete.keywordList) do
            if kw:sub(1, segmentLen) == lastSegment then
                table.insert(proposals, kw:sub(segmentLen + 1, #kw)..holder)
            end
        end
    if #proposals == 0 and holder:len() > 0 then
        table.insert(proposals, holder)
    end
    parameters.autocomplete.proposals = proposals or {}
end

local function modifyCurrentInput(modificationFunc)
    parameters._CurrentInput, parameters._cursorPosition = modificationFunc(parameters._CurrentInput, parameters._cursorPosition)
end

local baseDelay = 0
local keyState = {
    ["left"] = function(dt)
        leftkey = leftkey + 1
        baseDelay = baseDelay + 1
        if leftkey >= 4 and baseDelay > 20  then input.MoveCursorLeft() leftkey = 0 rightkey = 0 end
    end,
    ["backspace"] = function(dt)
        backspacekey = backspacekey + 1
        baseDelay = baseDelay + 1
        if backspacekey >= 4 and baseDelay > 20  then         
            modifyCurrentInput(function(input, pos)
                if pos > 1 then
                    return input:sub(1, pos - 2) .. input:sub(pos), pos - 1
                end
                return input, pos
            end) 
            leftkey = 0
            rightkey = 0
            backspacekey = 0
        end
    end,
    ["delete"] = function(dt)
        deletekey = deletekey + 1
        baseDelay = baseDelay + 1
        if deletekey >= 4 and baseDelay > 20  then         
            modifyCurrentInput(function(input, pos)
                return input:sub(1, pos - 1) .. input:sub(pos + 1), pos
            end) 
            leftkey = 0
            rightkey = 0
            deletekey = 0
        end
    end,
    ["right"] = function(dt)
        rightkey = rightkey + 1
        baseDelay = baseDelay + 1
        if rightkey >= 4 and baseDelay > 20 then input.MoveCursorRight() rightkey = 0  leftkey = 0 end
    end,
}

-- Function to modify the current input
function CheckIfKeyIsDown(dt)
    if not love.keyboard.isDown("left") and not love.keyboard.isDown("right") and not love.keyboard.isDown("backspace") and not love.keyboard.isDown("delete") then
        leftkey = 0
        rightkey = 0
        backspacekey = 0
        deletekey = 0
        baseDelay = 0
    end
    for key, value in pairs(keyState) do
        if love.keyboard.isDown(key) then
            cursorVisible = true
            value(dt)
        end
    end
end

-- Main update function for the console
function consoleUI.update(dt)
    UpdateCursor(dt)
    UpdateMouseState()
    UpdateAutocomplete()
    CheckIfKeyIsDown(dt)
end

print("Type $help for more commands in console")

return consoleUI

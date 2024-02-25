local parameters = require("lib.console.src.paramaters")
local consoleInput = require("lib.console.src.consoleInput")
local drawconsole = {}

local monoFont = love.graphics.newFont("lib/console/monospacefont/FiraCode-Retina.ttf", 13)

function drawconsole.Update(dt)-- check if moust button pressed and on edge if so then move that edge    
    consoleInput.consoleInput()
end

local function displaySavedText()
    -- display past entered font in console
    local font = love.graphics.getFont()
    love.graphics.setColor(.5,0,1,1)
    -- search ipairs and print
    local y = parameters.console.offsetY
    for i, text in ipairs(parameters.storageString) do
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print(tostring(i+99), parameters.console.offsetX, y) -- print line number instead of "*"
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(text, parameters.console.offsetX + font:getWidth(tostring(i+99)) + font:getWidth(" "), y) -- add space after line number
        y = y + font:getHeight() -- increment y by the height of the font to print on the next line
    end
end

local function displayInputText()
    -- Text Output 
    local font = love.graphics.getFont()
    love.graphics.setColor(1, 0, .5, 1)
    love.graphics.print(">", parameters.console.offsetX, parameters.console.height + parameters.console.offsetY - 15)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(parameters.inputString, parameters.console.offsetX + font:getWidth(">"), parameters.console.height + parameters.console.offsetY - 15)
end

function drawconsole.Draw()
    love.graphics.setFont(monoFont)
    -- Main Box Readout 
    love.graphics.setColor(parameters.console.backgroundColor)
    love.graphics.rectangle("fill", parameters.console.offsetX, parameters.console.offsetY, parameters.console.width, parameters.console.height)
    -- Main Outline
    love.graphics.setColor(parameters.console.outlineColor)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", parameters.console.offsetX, parameters.console.offsetY, parameters.console.width, parameters.console.height)
    -- Bottom Input Box
    love.graphics.setColor(.3, .3, .3, .5)
    love.graphics.rectangle("fill", parameters.console.offsetX, parameters.console.height + parameters.console.offsetY - 15, parameters.console.width, 15)
    displaySavedText()
    displayInputText()
end

return drawconsole
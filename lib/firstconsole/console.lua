-- Console utility functions for color-coded printing and table display
require("lib.firstconsole.src.hook")
local parameters = require("lib.firstconsole.src.parameters")
require("lib.firstconsole.src.testing")
local loveio = require("lib.firstconsole.src.io")
local console = {}

-- just use require("lib.firstconsole.src.console") to get this table
-- do it after your setup keyboard controls 
-- this hooks into many aspects of the love2d game but does not require alterations to your code so its easy to remove 


-- Generates color-coded strings based on value type
local function colorCode(value, cTable, valueType, isKey)
    local color = cTable[valueType .. (isKey and "Key" or "Value")] or "#ffffffff"
    if #color == 7 then color = color .. "FF" end
    return "|c" .. color .. tostring(value) .. "|r"
end

-- Function to print tables with color coding
local function printTable(t, indent, depth, done)
    done = done or {}
    indent = indent or 0
    local indentStr = string.rep(" ", indent)
    if depth < 0 then
        return
    end

    -- Collecting keys
    local keys = {}
    for key, _ in pairs(t) do
        table.insert(keys, key)
    end

    -- Custom sorting function
    table.sort(keys, function(a, b)
        -- Ensuring both keys are of comparable type
        if type(a) == type(b) then
            if type(a) == "number" and type(b) == "number" then
                return a < b -- numeric comparison
            else
                return tostring(a) < tostring(b) -- alphanumeric comparison
            end
        else
            return type(a) == "number" -- numbers first
        end
    end)

    -- Iterating through sorted keys
    for _, key in ipairs(keys) do
        local value = t[key]
        local valueType = type(value)
        local keyDisplay = colorCode(key, parameters.tableColors, valueType, true)
        local valueDisplay
        -- Value formatting remains unchanged
        if valueType == "function" then
            valueDisplay = colorCode("function", parameters.tableColors, valueType, false)
        elseif valueType == "string" then
            valueDisplay = colorCode("\"" .. value .. "\"", parameters.tableColors, valueType, false)
        elseif valueType == "number" then
            valueDisplay = colorCode(value, parameters.tableColors, valueType, false)
        elseif valueType == "table" and not done[value] then
            done[value] = true
            if depth > 0 then
                print(indentStr .. keyDisplay .. " {")
                printTable(value, indent + 4, depth - 1, done)
                print(indentStr .. "}")
            else
                valueDisplay = colorCode("TABLE", parameters.tableColors, valueType, false)
            end
        else
            valueDisplay = colorCode(value, parameters.tableColors, valueType, false)
        end
        if valueDisplay then
            print(indentStr .. keyDisplay .. " = " .. valueDisplay)
        end
    end
end


-- Function to print tables with a specified depth
local function Tprint(t, depth)
    if type(t) ~= "table" then print(tostring(t)) return end
    depth = depth or 3
    print("    {")
    printTable(t, 4, depth)
    print("}")
end

-- Predefined functions for color-coded warnings, errors, and info messages
local function Warn(incomingText) print("|c" .. parameters.colorWarn .. "warning:|r" .. tostring(incomingText)) end
local function Err(incomingText) print("|c" .. parameters.colorErr .. "error:|r".. tostring(incomingText)) end
local function Info(incomingText) print("|c" .. parameters.colorInfo .. "info:|r".. tostring(incomingText)) end


-- Function for custom color print
local function Cprint(color, text)
    local hexColor = parameters.colorMap[color] or color
    if #hexColor == 7 then hexColor = hexColor .. "FF" end
    print("|c" .. hexColor .. text .. "|r")
end

local function MonitorValue(name, valueOrFunction, hexColor)
    parameters.watchList[name] = {valueOrFunction = valueOrFunction, hexColor = hexColor}
end

-- add value or function to monitor 
local function AddMonitorValue(name, valueOrFunction, hexColor)
    if type(valueOrFunction) == "function" then
        parameters.watchList[name] = {valueOrFunction = valueOrFunction, hexColor = hexColor}
    else
        CPrint("#FF0000","You should pass this as a function to monitor: ")
        CPrint("green", "AddMonitorValue(\"name\", function() return value end, \"#RRGGBBAA\")")
    end
end

local function PrintDirectory(directory, depth)
    local dirContents = loveio.ListDirectory(directory)
    Tprint(dirContents, depth)
end


-- Define a set of default globals for exclusion
local defaultGlobalsSet = {
    _G = true, _VERSION = true, assert = true, collectgarbage = true, dofile = true, error = true,
    getmetatable = true, ipairs = true, load = true, loadfile = true, next = true, pairs = true,
    pcall = true, print = true, rawequal = true, rawget = true, rawset = true, select = true,
    setmetatable = true, tonumber = true, tostring = true, type = true, xpcall = true, loadstring = true,
    module = true, require = true, arg = true,
    -- Lua standard libraries
    coroutine = true, debug = true, io = true, math = true, os = true, package = true, string = true, table = true,
    -- Love2D specific globals
    love = true, graphics = true, audio = true, info = true, jit = true, bit = true, setfenv = true, getfenv = true, utf8 = true,
    UpdateJoystick = true, EngageHook = true, UpdateKeyboard = true, unpack = true, gcinfo=true, newproxy = true,
    -- others
}

-- Function to display non-default global variables
local function SeeGlobalVar(depth)
    local nonDefaultGlobals = {}
    for k, v in pairs(_G) do
        if not defaultGlobalsSet[k] then
            nonDefaultGlobals[k] = v
        end
    end
    Tprint(nonDefaultGlobals, depth)  -- Use a depth of 5, adjust as needed
end

-- Global debug output setting
if (parameters.globalDebugOutput) then
	_G.Warn = Warn
	_G.Err = Err
	_G.Info = Info
	_G.CPrint = Cprint
    _G.TPrint = Tprint
    _G.Monitor = MonitorValue
    _G.AddMonitor = AddMonitorValue
    _G.PrintDirectory = PrintDirectory
    _G.SeeGlobalVar = SeeGlobalVar
end

return console
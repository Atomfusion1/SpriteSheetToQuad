local parameters = {}

-- Utility Functions
function parameters.toRGBTable(hexString)
    if hexString:sub(1, 1) == "#" then
        hexString = hexString:sub(2)
    end
    local r = tonumber(hexString:sub(1, 2), 16) / 255
    local g = tonumber(hexString:sub(3, 4), 16) / 255
    local b = tonumber(hexString:sub(5, 6), 16) / 255
    local a = 1
    if (hexString:len() == 8) then
        a = tonumber(hexString:sub(7, 8), 16) / 255
    end
    return {r, g, b, a}
end


-- Internal State Variables
parameters._showConsole = false
parameters._consoleInFocus = false
parameters._isResizingBottom = false
parameters._isResizingTop = false
parameters._CurrentInput = ""
parameters._cursorPosition = 1
parameters._scrollPosition = 0
parameters._mode = "console"

-- Console Trigger and Key Settings
parameters.toggleKey = '`'
parameters.keyThroughConsole = true

-- Debug Output Colors
parameters.colorInfo = "#429BF4FF"
parameters.colorWarn = "#CECB2FFF"
parameters.colorErr = "#EA2A2AFF"

-- Console Layout and Appearance
parameters.backgroundColor = "#292958C7"
parameters.typingBarColor = "#292F48AF"
parameters.dragBarColor = "#AA141B93"
parameters.dragBarXOffset = 15
parameters.dragBarXLength = 5
parameters.dragBarYOffset = 15
parameters.dragBarYLength = 500
parameters.consoleStart = 20
parameters.consoleEnd = 200

-- Cursor and Input Settings
parameters.cursorStyle = "line"
parameters.selectedColor = "#ABABAB7F"
parameters.cursorBlockColor = "#FFFFFF7F"
parameters.cursorLineColor = "#FF8F8FFF"
parameters.inputTextColor = "#DFDFDFFF"
parameters.cursorBlinkDuration = 0.4

-- Buffer Settings
parameters.bufferTextColor = "#F5E1F5E7"
parameters.maxBufferEntries = 150

-- Storage for Input and Output Buffers
parameters.outputBuffer = {}
parameters.inputBuffer = {}

-- Watch List Settings
parameters.watchListXOffset = 700
parameters.watchListYOffset = 0
parameters.watchList = {
    ["FPS"] = {
        valueOrFunction = love.timer.getFPS,
        hexColor = "#76F166"
    },
}

-- Global Debug Output Setting
parameters.globalDebugOutput = true

parameters.autocomplete = {
    proposals = {},
    proposalIndex = 1,
    proposalPrefix = '',
    proposalColor = '#FF8F8FFF',
    keywordList = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while'},
    hideGlobalKeywords = {"coroutine", "debug", "io", "math", "os", "package", "string", "table", "bit32", "utf8", "arg", "_G", "_VERSION"},
}

-- Color map for easy reference in color-coded printing
parameters.colorMap = {
    red = "#FA0D2D",
    green = "#00FF00FF",
    blue = "#0000FFFF",
    yellow = "#FFFF00FF",
    orange = "#FFA500FF",
    purple = "#800080FF",
    pink = "#FFC0CBFF",
    brown = "#A52A2AFF",
    black = "#000000FF",
    white = "#FFFFFFFF",
    gray = "#808080FF",
    cyan = "#00FFFFFF",
    magenta = "#FF00FFFF",
    lime = "#00FF00FF",
    teal = "#008080FF",
}

-- Color settings for table display
parameters.tableColors = {
    tableKey = "#DA4FBB",
    tableValue = "#E57373FF",
    tableBrace = "#BABAC4FF",
    nonTableKey = "#82D4D4FF",
    nonTableValue = "#B2EFEFFF",
    header = "#805454FF",
    tableHolder = "#FF0000FF",
    functionKey = "#0EC7A8",
    functionValue = "#69B199",
    stringKey = "#FFFF00FF",
    stringValue = "#FFFF80FF",
    numberKey = "#71C503",
    numberValue = "#87B846",
    booleanKey = "#DF9A06",
    booleanValue = "#D4B061FB",
    defaultKey = "#B8A7A1",
    defaultValue = "#A9B19FEE",
}

return parameters

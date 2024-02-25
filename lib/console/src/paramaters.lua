

local parameters = {}

parameters.console = {
    name = "console",
    inputString = "",
    offsetX = 0,
    offsetY = 40,
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()/2,
    font = nil,
    fontSize = 0,
    fontColor = {0, 0, 0, 0},
    backgroundColor = {.3, .3, .3, .5},
    outlineColor = {.1, .1, 1, .8},
    alpha = 0,
    visible = true,
    active = true,
    text = "",
    shortcutKey = "`",
}

parameters.inputString = "Test Input text -->"
parameters.storageString = {
    "Test 1",
    "Test 2",
    "Test 3",
}



return parameters
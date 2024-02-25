local drawconsole = require("lib.console.src.drawconsole")
local parameters = require("lib.console.src.paramaters")
local console = {}

function console.Init()
    console.console = require("lib.firstconsole.console")
    console.console.Init()
end

function console.Update(dt)
    drawconsole.Update(dt)
end

function console.Draw()
    if parameters.console.visible then drawconsole.Draw() end
end

return console


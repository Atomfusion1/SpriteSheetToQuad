


local consolewindow = {}
local console = {}

function consolewindow.Load()
    print("Loading ConsoleWindow...")
        -- Initialize your console window here
        console = {
            x = 100,
            y = 100,
            width = 400,
            height = 300,
            isResizingBottom = false,
            isResizingTop = false,
            resizeBorder = 15 -- pixels from edge for resize area
        }
end

function consolewindow.Update(dt)
    --* Update ConsoleWindow
    if console.isResizingBottom then
        console.width = math.max(20, love.mouse.getX() - console.x)
        console.height = math.max(20, love.mouse.getY() - console.y)
    end
    if console.isResizingTop then
        console.x = love.mouse.getX()
        console.y = love.mouse.getY()
    end
    --! update mouse to show resize cursor ability when hovering over resize area
    if love.mouse.getX() > console.x + console.width - console.resizeBorder and love.mouse.getX() < console.x + console.width and
            love.mouse.getY() > console.y + console.height - console.resizeBorder and love.mouse.getY() < console.y + console.height then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizenesw"))
    elseif love.mouse.getX() > console.x and love.mouse.getX() < console.x + console.resizeBorder and
            love.mouse.getY() > console.y and love.mouse.getY() < console.y + console.resizeBorder then
        love.mouse.setCursor(love.mouse.getSystemCursor("sizenwse"))
    else
        love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
    end
end


function consolewindow.Draw()
    --* Draw ConsoleWindow
        -- Draw a semi-transparent rectangle for the console
    love.graphics.setColor(.5, .5, .5, 0.5) -- Semi-transparent black
    love.graphics.rectangle("fill", console.x, console.y, console.width, console.height)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end


function love.mousepressed(x, y, button)
    if button == 1 then
        if x > console.x + console.width - console.resizeBorder and x < console.x + console.width and
                y > console.y + console.height - console.resizeBorder and y < console.y + console.height then
            console.isResizingBottom = true
        end
        if x > console.x and x < console.x + console.resizeBorder and
                y > console.y and y < console.y + console.resizeBorder then
            console.isResizingTop = true
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        console.isResizingBottom = false
        console.isResizingTop = false
    end
end

return consolewindow
-- Local Variables
local displayTimer = {}

local cycleTime = 0
local sleepTime = 0
local timerForFPS = 0
local desiredFrameTime = 1 / 61.0
local lastFrameTime = 0
displayTimer.isDelaySkipped = false

--# Start the timer
function displayTimer.StartTimer()
    timerForFPS = love.timer.getTime()
end

--# Display performance metrics on the screen
function displayTimer.DisplayScreen()
    cycleTime = love.timer.getTime() - timerForFPS -- This timer is the amount of time it takes to update and draw the next screen
    UpdateScreenValues()
    DrawPerformanceMetrics()
    DelayScreen()
    timerForFPS = love.timer.getTime() -- This timer is the amount of time it takes to update and draw the next screen before delay for next frame
end

--# Update the screen values
function UpdateScreenValues()
    local elapsed = love.timer.getTime() - lastFrameTime
    sleepTime = desiredFrameTime - elapsed  -- Amount of time we need to sleep this frame, in seconds.
end

--# Delay the screen if needed
function DelayScreen()
    if sleepTime > 0 and not displayTimer.isDelaySkipped then
        love.timer.sleep(sleepTime)
    end
    lastFrameTime = love.timer.getTime()
end

--# Draw a metric on screen
local function DrawMetric(label, value, color, baseX, baseY)
    love.graphics.setColor(.4, 1, .4, 1) -- White color for the label
    love.graphics.print(label, baseX, baseY)
    local textWidth = love.graphics.getFont():getWidth(label)
    love.graphics.setColor(unpack(color)) -- Color for the value
    love.graphics.print(value, baseX + textWidth, baseY)
end

    
--# Draw the performance metrics
function DrawPerformanceMetrics()
    local baseX = 20 -- setup x location on screen
    local baseY = 5 -- setup height on screen
    love.graphics.setFont(love.graphics.newFont(12))
    local colorValue = {1, 0.3, 0.3, 1} -- Color for metric values
    -- FPS metric
    --DrawMetric("FPS: ", string.format("%d", love.timer.getFPS()), colorValue, baseX, baseY)
    baseX = baseX + 75
    -- Frame Time metric
    DrawMetric("Frame Time (us): ", string.format("%d", math.floor(cycleTime * 1000 * 1000)), colorValue, baseX, baseY)
    baseX = baseX + 160
    -- Memory usage metric
    DrawMetric("Memory (MB): ", string.format("%.2f", collectgarbage("count") / 1024), colorValue, baseX, baseY)
    baseX = baseX + 160
    -- Info text
    love.graphics.setColor(.3, .5, 1, 1)
    love.graphics.print("Press ` or esc x2", baseX, baseY)
    love.graphics.setColor(1, 1, 1, 1)
end


return displayTimer

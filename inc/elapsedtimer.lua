-- Usage example:
-- local elapsedTimer = require("inc/elapsedtimer")
-- local timer = elapsedTimer.new()
-- timer:SetTime(0, 0, 5, 0) -- Set the timer for 5 seconds
-- if timer:IsElapsed() then
-- if timer:IsElapsedSingle() then
-- if timer:IsElapsedRepeat() then
-- print(timer:TimeLeftString())
-- print(timer:TimeLeft())

local elapsedTimer = {}

-- elapsetimer.lua
local ElapsedTimer = {}
ElapsedTimer.__index = ElapsedTimer

-- function ElapsedTimer.new(hours, minutes, seconds, milliseconds)
function ElapsedTimer.new()
    local self = setmetatable({}, ElapsedTimer)
    self.startTime = love.timer.getTime() * 1000 -- Convert to milliseconds
    self.targetTime = 0
    return self
end

-- function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
-- returns nil
function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
    self.targetTime = (hours * 3600000) + (minutes * 60000) + (seconds * 1000) + milliseconds
    self.startTime = love.timer.getTime() * 1000 -- Convert to milliseconds
end

-- function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
-- Returns true if the target time has elapsed
function ElapsedTimer:IsElapsed()
    return (love.timer.getTime() * 1000) - self.startTime >= self.targetTime
end

-- function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
-- Returns true if the target time has elapsed and has not been triggered before
function ElapsedTimer:IsElapsedSingle()
    if not self.singleTriggered and self:IsElapsed() then
        self.singleTriggered = true
        return true
    end
    return false
end

-- function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
-- Returns true if the target time has elapsed and resets the timer
function ElapsedTimer:IsElapsedRepeat()
    if self:IsElapsed() then
        self:SetTime(
            math.floor(self.targetTime / 3600000), 
            math.floor((self.targetTime % 3600000) / 60000),
            math.floor((self.targetTime % 60000) / 1000),
            self.targetTime % 1000
        )
        return true
    end
    return false
end

-- function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
function ElapsedTimer:TimeLeft()
    return self.targetTime - ((love.timer.getTime() * 1000) - self.startTime)
end

-- function ElapsedTimer:SetTime(hours, minutes, seconds, milliseconds)
function ElapsedTimer:TimeLeftString()
    local remaining = self:TimeLeft()
    if remaining < 0 then remaining = 0 end

    local remainingHours = math.floor(remaining / 3600000)
    remaining = remaining % 3600000
    local remainingMinutes = math.floor(remaining / 60000)
    remaining = remaining % 60000
    local remainingSeconds = math.floor(remaining / 1000)
    remaining = remaining % 1000
    local remainingMilliseconds = remaining

    return string.format("%dh %dm %ds %dms", remainingHours, remainingMinutes, remainingSeconds, remainingMilliseconds)
end

return ElapsedTimer
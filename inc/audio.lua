
local audioFile = love.audio.newSource("assets/audio/Element1.mp3", "stream")
audioFile:setVolume(.01)
local audio = {}

function audio.Update(dt)
    if not audioFile:isPlaying() then
        audioFile:play()
    end
end

function audio.RaiseVolume()
    local currentVolume = love.audio.getVolume()
    if currentVolume < 1 then
        love.audio.setVolume(math.min(currentVolume + 0.03, 1))
    end
    print("Volume: " .. love.audio.getVolume())
end

function audio.LowerVolume()
    local currentVolume = love.audio.getVolume()
    if currentVolume > 0 then
        love.audio.setVolume(math.max(currentVolume - 0.03, 0))
    end
    print("Volume: " .. love.audio.getVolume())
end

return audio
local pngInput = require("src.pnginput")
local custFunc = require("inc.customFunc")

local editPNG = {}

--! LOAD Function
function editPNG.Load()
end

local function AnimationUpdate(dt)
    -- Update animation time and frame
    pngInput.animationTimer = pngInput.animationTimer + dt -- Increment the time by the elapsed time since last frame
    if pngInput.animationTimer >= pngInput.frameDuration then
        if #pngInput.frames > 0 then -- Make sure there are frames to animate
            pngInput.currentAnimationFrame = (pngInput.currentAnimationFrame % #pngInput.frames) + 1 -- Loop through frames
        end
        pngInput.animationTimer = pngInput.animationTimer - pngInput.frameDuration -- Reset animation time for the next frame
    end
end

--! UPDATE Function
function editPNG.Update(dt)
    AnimationUpdate(dt)
end

local function DrawBackgroundPNG()
    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white for proper rendering
    love.graphics.draw(pngInput.canvas, pngInput.offsetX, pngInput.offsetY, 0, pngInput.scale, pngInput.scale) -- Draw the entire canvas
end

local function FindMaxSize()
    local minLeftOffset, minTopOffset = 0, 0  -- Minimum extents for negative offsets
    local maxRightOffset, maxBottomOffset = 0, 0  -- Maximum extents considering positive offsets

    for i, quad in ipairs(pngInput.frames) do
        local _, _, w, h = quad:getViewport()
        local offsetX, offsetY = pngInput.offsetOfFrames[i].offsetX, pngInput.offsetOfFrames[i].offsetY
        minLeftOffset = math.min(minLeftOffset, offsetX)
        minTopOffset = math.min(minTopOffset, offsetY)
        maxRightOffset = math.max(maxRightOffset, offsetX + w)
        maxBottomOffset = math.max(maxBottomOffset, offsetY + h)
    end
    local totalWidth = maxRightOffset - minLeftOffset
    local totalHeight = maxBottomOffset - minTopOffset
    return totalWidth, totalHeight, minLeftOffset, minTopOffset
end

local function DrawFrames()
    --@ Draw all selected frames next to each other
    local offsetpngX = pngInput.offsetX + pngInput.pngWidth -- Starting X position for drawing frames
    local totalWidth, totalHeight, minLeftOffset, minTopOffset = FindMaxSize()
    --! Draw all selected frames onto the new canvas
    local currentX = 0  -- Start from the beginning of the canvas
    for i, quad in ipairs(pngInput.frames) do
        local _, _, frameWidth, frameHeight = quad:getViewport()
        local offsetX, offsetY = offsetpngX + pngInput.offsetOfFrames[i].offsetX, pngInput.offsetOfFrames[i].offsetY
        
        -- Adjust position based on the minimum offsets
        -- This effectively translates all frames so that the one with the most negative offset is placed at (0,0)
        local drawX = currentX + (offsetX - minLeftOffset)
        local drawY = offsetY - minTopOffset  -- Move down if there's a negative vertical offset
        local offsetDown =  totalHeight - frameHeight
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white for proper rendering
        love.graphics.draw(pngInput.editPNG, quad, drawX, drawY + 40+offsetDown)

        if i == pngInput.currentFrame then
            love.graphics.setColor(1, 0, 0, 1) -- Set the color to red for the current frame
            love.graphics.rectangle("line", drawX, drawY + 40+offsetDown, frameWidth, frameHeight)
        end
        
        -- Increment currentX by maxWidth for the next frame to be drawn beside the current one
        currentX = currentX + totalWidth  -- This assumes spacing based on the widest frame
    end
end

local function DrawSelectedArea()
    -- Draw the current selection with a red, semi-transparent rectangle
    love.graphics.setColor(1, 0, 0, 0.5) -- Set the color to red and 50% transparent
    love.graphics.rectangle("fill", pngInput.selectionOffsetX + 40, pngInput.selectionOffsetY + 40, pngInput.selectionWidth, pngInput.selectionHeight)
end

local function GetMaxFrameSize()
    -- Get the maximum width and height of the frames
    local maxWidth = pngInput.selectionWidth
    local maxHeight = pngInput.selectionHeight
    for i, frame in ipairs(pngInput.frames) do
        local frameX, frameY, frameWidth, frameHeight = frame:getViewport()
        maxWidth = math.max(maxWidth, frameWidth)
        maxHeight = math.max(maxHeight, frameHeight)
    end
    return maxWidth, maxHeight
end

local function DrawLiveFrame()
    if not pngInput.isAnimationPlaying then
        local maxWidth, maxHeight = GetMaxFrameSize()
        local offsetX = (maxWidth - pngInput.selectionWidth) / 2 -- Calculate the offset to center the frame
        local offsetY = (maxHeight- pngInput.selectionHeight) -- Calculate the offset to center the frame
        local smallOffsetX = pngInput.offsetOfFrames[pngInput.currentFrame].offsetX
        local smallOffsetY = pngInput.offsetOfFrames[pngInput.currentFrame].offsetY
        local tempQuad = love.graphics.newQuad(pngInput.selectionOffsetX, pngInput.selectionOffsetY, pngInput.selectionWidth, pngInput.selectionHeight, pngInput.pngWidth, pngInput.pngHeight)
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white for proper rendering
        love.graphics.draw(pngInput.editPNG, tempQuad, pngInput.pngWidth + 50 + smallOffsetX , 200 + offsetY*3 + smallOffsetY, 0, 3, 3)
    end
end

local function DrawPersistantFrames()
    if pngInput.isPersistantImage then
        local maxWidth, maxHeight = GetMaxFrameSize()
        local offsetX = (maxWidth - pngInput.selectionWidth) / 2 -- Calculate the offset to center the frame
        local offsetY = (maxHeight- pngInput.selectionHeight) -- Calculate the offset to center the frame
        local smallOffsetX = pngInput.offsetOfFrames[pngInput.currentFrame].offsetX
        local smallOffsetY = pngInput.offsetOfFrames[pngInput.currentFrame].offsetY
        if pngInput.frames[pngInput.currentFrame] then
            love.graphics.setColor(1, 1, 1, .4) -- Reset color to white for proper rendering
            love.graphics.draw(pngInput.editPNG, pngInput.frames[pngInput.currentFrame], pngInput.pngWidth + 50 + smallOffsetX, 200 + offsetY*3 + smallOffsetY, 0, 3, 3 )
            love.graphics.setColor(1, 1, 1, .5) -- Reset color to white for proper rendering
            if pngInput.frames[pngInput.currentFrame - 1] then
                local frameX, frameY, frameWidth, frameHeight = pngInput.frames[pngInput.currentFrame - 1]:getViewport()
                local offsetX = (maxWidth - frameWidth) / 2 -- Calculate the offset to center the frame
                local offsetY = (maxHeight- frameHeight) -- Calculate the offset to center the frame
                local smallOffsetX = pngInput.offsetOfFrames[pngInput.currentFrame-1].offsetX
                local smallOffsetY = pngInput.offsetOfFrames[pngInput.currentFrame-1].offsetY
                love.graphics.draw(pngInput.editPNG, pngInput.frames[pngInput.currentFrame-1], pngInput.pngWidth + 50 + smallOffsetX, 200 + offsetY*3 + smallOffsetY, 0, 3, 3 )
            end
        end
    end
end

local function DrawAnimation()
    -- Draw the current frame of the animation
    if pngInput.isAnimationPlaying then
        local maxWidth, maxHeight = GetMaxFrameSize()
        if #pngInput.frames > 0 and pngInput.frames[pngInput.currentAnimationFrame] then
            local frameX, frameY, frameWidth, frameHeight = pngInput.frames[pngInput.currentAnimationFrame]:getViewport()
            local offsetX = (maxWidth - frameWidth) / 2 -- Calculate the offset to center the frame
            local offsetY = (maxHeight- frameHeight) -- Calculate the offset to center the frame
            local smallOffsetX = pngInput.offsetOfFrames[pngInput.currentAnimationFrame].offsetX
            local smallOffsetY = pngInput.offsetOfFrames[pngInput.currentAnimationFrame].offsetY
            local animatedFrame = pngInput.frames[pngInput.currentAnimationFrame] -- Get the current frame from the list
            love.graphics.setColor(1, 1, 1, 1) -- Reset color to white for proper rendering
            love.graphics.draw(pngInput.editPNG, animatedFrame, pngInput.pngWidth + 50 + smallOffsetX, 200+offsetY*3 + smallOffsetY, 0, 3, 3) -- Draw the animated frame (change '800 - 122' to where you want)
        end
    end
end

local function GetMode()
    -- Get the current mode of the application
    if pngInput.isAnimationPlaying then
        return "Animation"
    elseif pngInput.isPersistantImage then
        return "Persistant"
    else
        return "Current Frame"
    end
end

local function DrawInformation(x,y)
    -- Draw the information about the current frame
    love.graphics.setColor(1, 1, 0, 1) -- Reset color to white for proper rendering
    custFunc.PrintColorString("Current Mode: (1,1,0,1)" .. GetMode(), x, y) -- Print the current frame of
    custFunc.PrintColorString("File Saved Name: (1,.8,.3,1)" .. pngInput.lastSaveFileName, x, y+15) -- Print the current frame of
    custFunc.PrintColorString("Current Frame: (1,.5,0,1)" .. pngInput.currentFrame, x, y+30) -- Print the current frame of
    custFunc.PrintColorString("(1,1,1,1)Offset X:(1,.5,0,1)" .. pngInput.selectionOffsetX .. "(1,1,1,1) Offset Y:(1,.5,0,1)" .. pngInput.selectionOffsetY .. "(1,1,1,1) Width:(1,.5,0,1)" .. pngInput.selectionWidth .. "(1,1,1,1) Height:(1,.5,0,1)" .. pngInput.selectionHeight, x, y+45) -- Print the current frame of
    custFunc.PrintColorString("(1,1,1,1)Frame Offset X:(1,.5,0,1)" .. pngInput.offsetOfFrames[pngInput.currentFrame].offsetX .. "(1,1,1,1) Frame Offset Y:(1,.5,0,1)" .. pngInput.offsetOfFrames[pngInput.currentFrame].offsetY, x, y+60) -- Print the current frame of
    local maxWidth, maxHeight = FindMaxSize()
    custFunc.PrintColorString("Maximum Frame Width: (1,.5,0,1)" .. maxWidth, x, y+75) -- Print
end

-- convert this section to use printcolorstring and yellow befor: white : and a red string after

local function DrawHelp(x, y)
    custFunc.PrintColorString("(1,1,1,1)Help Commands:(1,1,1,1)", x, y)
    custFunc.PrintColorString("(1,1,0,1)q(1,0,0,1):(1,1,1,1) delete frame", x, y+15)
    custFunc.PrintColorString("(1,1,0,1)r(1,0,0,1):(1,1,1,1) add frame", x, y+30)
    custFunc.PrintColorString("(1,1,0,1)e(1,0,0,1):(1,1,1,1) edit current frame", x, y+45)
    custFunc.PrintColorString("(1,1,0,1)space(1,0,0,1):(1,1,1,1) enable/disable animation", x, y+60)
    custFunc.PrintColorString("(1,1,0,1)p(1,0,0,1):(1,1,1,1) enable/disable persistent image", x, y+75)
    custFunc.PrintColorString("(1,1,0,1)s(1,0,0,1):(1,1,1,1) saves current frame into appdata.love", x, y+90)
    custFunc.PrintColorString("(1,1,0,1)arrows(1,0,0,1):(1,1,1,1) move around selection box", x, y+105)
    custFunc.PrintColorString("(1,1,0,1)kp+(1,0,0,1):(1,1,1,1) increase current frame", x, y+120)
    custFunc.PrintColorString("(1,1,0,1)kp-(1,0,0,1):(1,1,1,1) decrease current frame", x, y+135)
    custFunc.PrintColorString("(1,1,0,1)Align Sprites Bottom Left Corner", x, y+150)
    custFunc.PrintColorString("(1,1,0,1)hold ctrl and arrows(1,0,0,1):(1,1,1,1) move frame inside of canvas box", x, y+165)
end


--! DRAW Function
function editPNG.Draw()
    DrawBackgroundPNG()     --# Draw the background image
    DrawFrames()            --# Draw all selected frames
    DrawPersistantFrames()  --# Draw all persistent frames
    DrawAnimation()         --# Draw the current frame of the animation
    DrawLiveFrame()         --# Draw the current frame
    DrawSelectedArea()      --# Draw the current selection
    DrawInformation(40, pngInput.pngHeight + 40)       --# Draw the information
    DrawHelp(40 , pngInput.pngHeight + 200)              --# Draw the help
end



return editPNG
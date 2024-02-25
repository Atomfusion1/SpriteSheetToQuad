local pngInput = require("src.pnginput")

local SavingPNG = {}

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
    

function SavingPNG.SaveNow(fileName)
    if #pngInput.frames < 1 then return end

    --! Get the dimensions of the largest quad
    local maxWidth, maxHeight, minLeftOffset, minTopOffset = 0, 0, 0, 0           --# Track the maximum dimensions
    maxWidth, maxHeight, minLeftOffset, minTopOffset = FindMaxSize()

    --! Now, maxWidth and maxHeight hold the largest dimensions found
    local totalWidth = (#pngInput.frames * (maxWidth))
    local newCanvas = love.graphics.newCanvas(totalWidth, maxHeight) -- Use maxHeight for canvas height

    local baseFilename = fileName
    local extension = '.png'

    --# Construct the base filename with the first frame's dimensions
    baseFilename = baseFilename .. "_" .. maxWidth .. "x" .. maxHeight
    local filename = baseFilename .. extension
    local counter = 1

    --! Check if the file exists and create a new filename if it does
    while love.filesystem.getInfo(filename) do
        filename = baseFilename .."_".. tostring(counter) .. extension
        counter = counter + 1
    end

    --! Canvas Setup 
    love.graphics.setCanvas(newCanvas)
    love.graphics.clear() -- Clear the canvas before drawing

    --! Draw all selected frames onto the new canvas
    local currentX = 0  -- Start from the beginning of the canvas
    for i, quad in ipairs(pngInput.frames) do
        local _, _, frameWidth, frameHeight = quad:getViewport()
        local offsetX, offsetY = pngInput.offsetOfFrames[i].offsetX, pngInput.offsetOfFrames[i].offsetY
        
        -- Adjust position based on the minimum offsets
        -- This effectively translates all frames so that the one with the most negative offset is placed at (0,0)
        local drawX = currentX + (offsetX - minLeftOffset)
        local drawY = offsetY - minTopOffset  -- Move down if there's a negative vertical offset
        local offsetDown =  maxHeight - frameHeight
        love.graphics.draw(pngInput.editPNG, quad, drawX, drawY + offsetDown)
        
        -- Increment currentX by maxWidth for the next frame to be drawn beside the current one
        currentX = currentX + maxWidth  -- This assumes spacing based on the widest frame
    end


    love.graphics.setCanvas() --! Reset canvas to the main screen before encode

    --! Save the new canvas as an image file
    newCanvas:newImageData():encode('png', filename)
    pngInput.lastSaveFileName = filename
end

return SavingPNG

love.graphics.setDefaultFilter("nearest", "nearest")

local pngInput = {}
pngInput.frames = {}            -- table of frames collected
pngInput.offsetOfFrames = {
    [1] = {
        offsetX = 0,
        offsetY = 0
    }
}   -- table of offsets of frames in the png
pngInput.currentFrame = 1
pngInput.lastSaveFileName = ""
--! PNG Information and variables
pngInput.editPNG = love.graphics.newImage("assets/images/MegaManX.png")
pngInput.squareBackground = love.graphics.newImage("assets/images/Squares.png")
pngInput.pngWidth = pngInput.editPNG:getWidth()
pngInput.pngHeight = pngInput.editPNG:getHeight()
pngInput.canvas = love.graphics.newCanvas(pngInput.pngWidth, pngInput.pngHeight)
pngInput.pngQuad = love.graphics.newQuad(0, 0, pngInput.pngWidth, pngInput.pngHeight, 1,1)
pngInput.offsetX = 40   -- image offset from the top left corner
pngInput.offsetY = 40
pngInput.scale = 1
pngInput.mouseOffsetX = 0
pngInput.mouseOffsetY = 0

--! Dragging and selection variables
pngInput.selectionOffsetX = 0
pngInput.selectionOffsetY  = 0
pngInput.selectionWidth =  40
pngInput.selectionHeight = 80
pngInput.moveAmount = 1             -- shift box by 1 on arrow key press
pngInput.shiftMoveAmount = 10       -- shift box by 10 on shift + arrow key press
pngInput.dragging = false
pngInput.expand = false

--! Animation variables
pngInput.isAnimationPlaying = false
pngInput.currentAnimationFrame = 1
pngInput.animationTimer = 0
pngInput.frameDuration = 0.25

--! Image Display
pngInput.isPersistantImage = false


-- Assuming these are defined somewhere:
local viewWidth, viewHeight = 600, 600  -- Size of the viewport

pngInput.UpdateQuad = function(self)
    local quadWidth = math.min(self.pngWidth, viewWidth / pngInput.scale)
    local quadHeight = math.min(self.pngHeight, viewHeight / pngInput.scale)
    self.pngQuad:setViewport(self.mouseOffsetX, self.mouseOffsetY, quadWidth, quadHeight, self.pngWidth, self.pngHeight)
end

pngInput.UpdateQuad(pngInput)

--@ Setup PNG Canvas
love.graphics.setCanvas(pngInput.canvas)
love.graphics.setColor(1,1,1,.8)
love.graphics.draw(pngInput.squareBackground)
love.graphics.setColor(1,1,1,1)
love.graphics.draw(pngInput.editPNG, 0, 0, 0, 1, 1)
love.graphics.setCanvas() -- Reset the active canvas


return pngInput
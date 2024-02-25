


local func = {}

-- when string is provided as a parameter, it will be print on the screen and parse out (1,1,1,1) 
-- example func.PrintColorString("(1,0,1,1)TestMe (0,0,1,1)Test Me", 20, 650)
-- parse out the (1,1,1,1) and set the color to the color provided
-- I want to have the ability of multi color string
-- then print the rest of the string
--! Parse Color out of String
function ParseColorString(colorStr)
    local color = {}
    for value in colorStr:gmatch('([^,]+)') do
        table.insert(color, tonumber(value))
    end
    return color
end

--! Print Multi Color String 
func.PrintColorString = function(str, x, y)
    local defaultColor = {1, 1, 1, 1}
    local i = 1
    local startPrintPos = 1
    love.graphics.setColor(defaultColor) -- Set default color before starting

    while i <= #str do
        if str:sub(i, i) == "(" then
            if i > startPrintPos then                       -- Print previous segment if there is any
                local segment = str:sub(startPrintPos, i - 1)
                love.graphics.print(segment, x, y)
                x = x + love.graphics.getFont():getWidth(segment)
            end
            local finish = i
            while str:sub(finish, finish) ~= ")" and finish <= #str do
                finish = finish + 1
            end
            local colorStr = str:sub(i + 1, finish - 1)     -- Extract and apply new color
            local color = ParseColorString(colorStr)        -- Use the new function
            if #color == 4 then                             -- Check if color is correctly formatted
                love.graphics.setColor(color)
            else
                love.graphics.setColor(defaultColor)        -- Reset to default if format is wrong
            end
            i = finish + 1
            startPrintPos = i                               -- Update start position for next text segment
        else
            i = i + 1                                       -- Move to the next character if not starting color code
        end
    end
    if startPrintPos <= #str then               --# Print the remaining part of the string if there is any
        local segment = str:sub(startPrintPos)
        love.graphics.print(segment, x, y)
    end
    love.graphics.setColor(defaultColor)        --# Reset to default color after printing
end




return func
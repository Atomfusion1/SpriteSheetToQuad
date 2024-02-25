local path = (...):gsub("%.", "/")
local path_load = path:sub(1, -7)
print(love.filesystem.getSource() .."/" .. path_load .. "save/")

local loveio = {}

-- Saves key-value pairs to a file
function loveio.SaveToFile(filename, data_table)
    local file_path = love.filesystem.getSource() .. "/" .. path_load .. "save/" .. filename
    local f = io.open(file_path, "w+")
    if not f then
        print("Error: Unable to open file for writing: " .. file_path)
        return
    end
    for key, value in pairs(data_table) do
        if not key:match("^_") and (type(value) == "string" or type(value) == "number" or type(value) == "boolean") then
            f:write(key .. "=" .. tostring(value) .. "\n")
        end
    end
    f:close()
end

function loveio.LoadFromFile(filename, data_table)
    local file_path = love.filesystem.getSource() .. "/" .. path_load .. "save/" .. filename
    local f = io.open(file_path, "r")
    if not f then
        print("Error: Unable to open file for reading: " .. file_path)
        return
    end
    for line in f:lines() do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and value and data_table[key] ~= nil then
            local currentType = type(data_table[key])
            if currentType == "number" then
                value = tonumber(value) or value
            elseif currentType == "boolean" then
                if value == "true" then
                    value = true
                elseif value == "false" then
                    value = false
                end
            end
            data_table[key] = value
        end
    end
    f:close()
end


-- Saves ipairs to a file
function loveio.SaveIPairToFile(filename, data_table)
    local file_path = love.filesystem.getSource() .. "/" .. path_load .. "save/" .. filename
    local f = io.open(file_path, "w+")
    if not f then
        print("Error: Unable to open file for writing: " .. file_path)
        return
    end
    for _, value in ipairs(data_table) do
        f:write(value .. "\n")
    end
    f:close()
end

-- Loads ipairs from a file
function loveio.LoadIPairFromFile(filename, data_table)
    local file_path = love.filesystem.getSource() .. "/" .. path_load .. "save/" .. filename
    local f = io.open(file_path, "r")
    if not f then
        print("Error: Unable to open file for reading: " .. file_path)
        return
    end
    -- Clear the contents of data_table
    for k in pairs(data_table) do
        data_table[k] = nil
    end
    for line in f:lines() do
        table.insert(data_table, line)
    end
    f:close()
end

function loveio.ListDirectory(directory)
    -- Helper function to recursively list items
    local function listItems(dir, path)
        local files = {}
        local items = love.filesystem.getDirectoryItems(dir)
        for _, item in ipairs(items) do
            local itemPath = path and (path .. '/' .. item) or item
            local info = love.filesystem.getInfo(dir .. '/' .. item)
            if info then
                if info.type == "directory" then
                    -- It's a directory, so recursively list its contents
                    files[item] = listItems(dir .. '/' .. item, "file")
                else
                    -- It's a file, add to the list
                    files[item] = "file"
                end
            end
        end
        return files
    end

    return listItems(directory, '')
end



return loveio

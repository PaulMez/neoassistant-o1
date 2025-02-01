-- lua/neoassistant-o1/utils.lua

local M = {}

-- Utility function to read a file
function M.read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil, "Cannot open file: " .. path
    end
    local content = file:read("*a")
    file:close()
    return content
end

-- Utility function to write to a file
function M.write_file(path, content)
    local file = io.open(path, "w")
    if not file then
        return false, "Cannot write to file: " .. path
    end
    file:write(content)
    file:close()
    return true
end

return M
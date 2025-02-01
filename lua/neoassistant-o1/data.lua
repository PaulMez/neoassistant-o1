-- lua/neoassistant-o1/data.lua

local M = {}

local json = vim.json -- Requires Neovim 0.9+; for older versions, use a JSON parser like dkjson

function M.load_shortcuts()
    local file_path = vim.fn.stdpath('data') .. '/neoassistant-o1/shortcuts.json'
    local file = io.open(file_path, "r")
    if not file then
        vim.notify("NeoAssistant-o1: Cannot find shortcuts.json", vim.log.levels.ERROR)
        return {}
    end
    local content = file:read("*a")
    file:close()
    local ok, data = pcall(json.decode, content)
    if not ok then
        vim.notify("NeoAssistant-o1: Error parsing shortcuts.json", vim.log.levels.ERROR)
        return {}
    end
    return data
end

return M
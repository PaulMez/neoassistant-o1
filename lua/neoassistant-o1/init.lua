-- lua/neoassistant-o1/init.lua

local M = {}

M.ui = require("neoassistant-o1.ui")
M.data = require("neoassistant-o1.data")
M.tracker = require("neoassistant-o1.tracker")
M.utils = require("neoassistant-o1.utils") -- Utility functions

print("NeoAssistant-o1 Plugin initialized!")

-- Function to handle setting suggestions
function M.set_suggestion(flag)
    vim.b.neoassistant-o1_suggestion = flag
end

-- Setup function for user configurations
function M.setup(user_config)
    user_config = user_config or {}
    
    -- Allow users to override the toggle key mapping
    local toggle_key = user_config.toggle_key or "<leader>cs"
    vim.api.nvim_set_keymap('n', toggle_key, ':lua ToggleNeoAssistant-o1()<CR>', { noremap = true, silent = true })
    
    -- Additional configurations can be handled here
end

return M
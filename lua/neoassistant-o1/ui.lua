-- lua/neoassistant-o1/ui.lua

local M = {}

local api = vim.api
local data = require("neoassistant-o1.data")
local tracker = require("neoassistant-o1.tracker")

local win_id = nil
local buf_id = nil

-- Create floating window
function M.create_window(content)
    if win_id and api.nvim_win_is_valid(win_id) then
        api.nvim_buf_set_lines(buf_id, 0, -1, false, content)
        return
    end

    buf_id = api.nvim_create_buf(false, true) -- No file from buffer, scratch
    api.nvim_buf_set_lines(buf_id, 0, -1, false, content)

    local width = math.floor(vim.o.columns * 0.3)
    local height = math.floor(vim.o.lines * 0.3)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
    }

    win_id = api.nvim_open_win(buf_id, false, opts)
    api.nvim_win_set_option(win_id, 'wrap', true)
    api.nvim_win_set_option(win_id, 'cursorline', false)
end

-- Gather shortcuts to display based on usage
local function get_display_shortcuts(shortcuts, usage)
    local display = {}
    for _, sc in ipairs(shortcuts) do
        local count = usage[sc.shortcut[1]] or 0
        if count >= sc.conditions.min_usage and count <= sc.conditions.max_usage then
            table.insert(display, string.format("[Mode: %s] %s: %s (Replaces: %s)", sc.mode, table.concat(sc.shortcut, ", "), sc.description, table.concat(sc.replaces, ", ")))
        end
    end
    return display
end

-- Gather suggestions
local function get_suggestions()
    local suggestions = {}
    -- Example suggestion
    if (vim.b.neoassistant-o1_suggestion) then
        table.insert(suggestions, "[Suggestion] You are frequently using 'l'. Consider using `w` to jump to the next word, `e` to jump to the end of the word, or map a shortcut to skip words.")
    end
    return suggestions
end

-- Main function to show cheat sheet
function M.show_cheatsheet()
    local shortcuts = data.load_shortcuts()
    local usage = tracker.load_usage()
    local display = get_display_shortcuts(shortcuts, usage)
    local suggestions = get_suggestions()

    -- Combine display and suggestions
    local content = {}
    for _, line in ipairs(display) do
        table.insert(content, line)
    end
    if #suggestions > 0 then
        table.insert(content, "")  -- Add a blank line
        for _, suggestion in ipairs(suggestions) do
            table.insert(content, suggestion)
        end
        -- Reset the suggestion flag after displaying
        require('neoassistant-o1').set_suggestion(false)
    end

    M.create_window(content)
end

-- Toggle function
function M.toggle_cheatsheet()
    if win_id and api.nvim_win_is_valid(win_id) then
        api.nvim_win_close(win_id, true)
        win_id = nil
        buf_id = nil
    else
        M.show_cheatsheet()
    end
end

return M
-- lua/neoassistant-o1/tracker.lua

local M = {}

local json = vim.json
local uv = vim.loop

local usage_file = vim.fn.stdpath('data') .. '/neoassistant-o1/user_usage.json'

-- Load usage data
function M.load_usage()
    local file = io.open(usage_file, "r")
    if not file then
        return {}
    end
    local content = file:read("*a")
    file:close()
    local ok, data = pcall(json.decode, content)
    if not ok then
        vim.notify("NeoAssistant-o1: Error parsing user_usage.json", vim.log.levels.ERROR)
        return {}
    end
    return data
end

-- Save usage data
function M.save_usage(data)
    local file = io.open(usage_file, "w")
    if not file then
        vim.notify("NeoAssistant-o1: Cannot write user_usage.json", vim.log.levels.ERROR)
        return
    end
    local content = json.encode(data)
    file:write(content)
    file:close()
end

-- Debounced increment usage count
local debounce_timer = nil
local debounce_interval = 1000 -- 1 second
local pending_updates = {}

function M.increment_usage(shortcut)
    pending_updates[shortcut] = (pending_updates[shortcut] or 0) + 1

    if debounce_timer then
        debounce_timer:stop()
    else
        debounce_timer = uv.new_timer()
    end

    debounce_timer:start(debounce_interval, 0, function()
        uv.schedule(function()
            local usage = M.load_usage()
            for sc, count in pairs(pending_updates) do
                usage[sc] = (usage[sc] or 0) + count
            end
            M.save_usage(usage)
            pending_updates = {}
            debounce_timer:stop()
        end)
    end)
end

-- Reset usage count (useful for certain conditions)
function M.reset_usage(shortcut)
    local usage = M.load_usage()
    usage[shortcut] = 0
    M.save_usage(usage)
end

-- Setup tracking for shortcuts
function M.setup_tracking(shortcuts)
    for _, sc in ipairs(shortcuts) do
        for _, key in ipairs(sc.shortcut) do
            -- Define a global key mapping that increments usage
            vim.keymap.set(sc.mode, key, function()
                M.increment_usage(key)
                -- Execute the actual command
                vim.cmd(sc.actual_command or '')
            end, { noremap = true, silent = true })
        end
    end
end

-- Register a callback for specific key patterns
local suggestion_callbacks = {}

function M.on_pattern_detected(pattern, callback)
    suggestion_callbacks[pattern] = callback
end

-- Function to detect patterns and invoke callbacks
function M.detect_patterns()
    -- Define patterns
    local patterns = {
        {
            key = 'l',
            threshold = 5,  -- Number of presses before suggesting
            timeframe = 2000, -- Timeframe in milliseconds
            callback = function()
                vim.schedule(function()
                    vim.notify("[NeoAssistant-o1] You frequently press 'l'. Consider using more efficient navigation commands like `w`, `e`, or mappings to skip words.", vim.log.levels.INFO)
                    -- Set flag for cheat sheet
                    require('neoassistant-o1').set_suggestion(true)
                end)
            end,
        },
        -- Add more patterns as needed
    }

    local timers = {}

    for _, pattern in ipairs(patterns) do
        local key = pattern.key
        local threshold = pattern.threshold
        local timeframe = pattern.timeframe
        local callback = pattern.callback

        -- Override the key mapping to include pattern detection
        vim.api.nvim_set_keymap('n', key, '', { noremap = true, silent = true, callback = function()
            -- Increment usage
            M.increment_usage(key)

            -- Initialize or update timer
            if timers[key] then
                timers[key].count = timers[key].count + 1
                timers[key].timer:stop()
                timers[key].timer:start(timeframe, 0, vim.schedule_wrap(function()
                    if timers[key].count >= threshold then
                        callback()
                        M.reset_usage(key)
                    end
                    timers[key].count = 0
                end))
            else
                timers[key] = {
                    count = 1,
                    timer = uv.new_timer(),
                }
                timers[key].timer:start(timeframe, 0, vim.schedule_wrap(function()
                    if timers[key].count >= threshold then
                        callback()
                        M.reset_usage(key)
                    end
                    timers[key].count = 0
                end))
            end

            -- Execute the actual command mapped to the key
            vim.cmd("normal " .. key)
        end })
    end
end

return M
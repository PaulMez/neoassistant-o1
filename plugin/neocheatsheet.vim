" plugin/neoassistant-o1.vim

lua << EOF
local neoassistant-o1 = require('neoassistant-o1')

-- Setup function
function _G.ToggleNeoAssistant-o1()
    neoassistant-o1.ui.toggle_cheatsheet()
end

-- User configurations
neoassistant-o1.setup({
    toggle_key = '<leader>cs'  -- Users can change this in their config
})

-- Load shortcuts and setup tracking
local shortcuts = neoassistant-o1.data.load_shortcuts()
neoassistant-o1.tracker.setup_tracking(shortcuts)

-- Setup pattern detection for dynamic suggestions
neoassistant-o1.tracker.detect_patterns()
EOF
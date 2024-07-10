local oil = require("oil")
local wk = require("which-key")

oil.setup({
    view_options = {
        -- Show files and directories that start with "." by default
        show_hidden = true,
        -- But never '..'
        is_always_hidden = function(name, bufnr)
            return name == ".."
        end,
    },
})

local keys = {
    ["-"] = { oil.open, "Open parent directory" },
}

wk.register(keys)

local wk = require("which-key")
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")

local keys = {
    f = {
        name = "Fuzzy finder",
        b = { telescope_builtin.buffers, "Open buffers" },
        f = { telescope_builtin.git_files, "Git tracked files" },
        F = { telescope_builtin.find_files, "Files" },
        g = { telescope_builtin.live_grep, "Grep string" },
        G = { telescope_builtin.grep_string, "Grep string under cursor" },
        n = { telescope.extensions.notify.notify, "Notification history" },
    },
}

wk.register(keys, { prefix = "<leader>" })

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
                -- I want the normal readline mappings rather than scrolling
                ["<C-u>"] = false,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("lsp_handlers")

local keys = {
    f = {
        name = "Fuzzy finder",
        b = { telescope_builtin.buffers, "Open buffers" },
        f = { telescope_builtin.git_files, "Git tracked files" },
        F = { telescope_builtin.find_files, "Files" },
        g = { telescope_builtin.live_grep, "Grep string" },
        G = { telescope_builtin.grep_string, "Grep string under cursor" },
    },
}

wk.register(keys, { prefix = "<leader>" })

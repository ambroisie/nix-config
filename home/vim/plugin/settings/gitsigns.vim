lua << EOF
local gitsigns = require('gitsigns')

gitsigns.setup({
    -- I dislike the full-green sign column when this happens
    attach_to_untracked = false,

    current_line_blame_opts = {
        -- Show the blame quickly
        delay = 100,
    },

    on_attach = function(bufnr)
        local wk = require("which-key")

        local keys = {
            -- Navigation
            ["[c"] = { "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", "Previous hunk/diff", expr = true },
            ["]c"] = { "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", "Next hunk/diff", expr = true },


            -- Commands
            ["<leader>g"] = {
                name = "Git",
                -- Actions
                b = { gitsigns.toggle_current_line_blame, "Toggle blame virtual text" },
                d = { gitsigns.diffthis, "Diff buffer" },
                D = { function() gitsigns.diffthis("~") end, "Diff buffer against last commit" },
                h = { gitsigns.toggle_deleted, "Show deleted hunks" },
                p = { gitsigns.preview_hunk, "Preview hunk" },
                r = { gitsigns.reset_hunk, "Revert hunk" },
                R = { gitsigns.reset_buffer, "Revert buffer" },
                s = { gitsigns.stage_hunk, "Stage hunk" },
                S = { gitsigns.stage_buffer, "Stage buffer" },
                u = { gitsigns.undo_stage_hunk, "Undo stage hunk" },
                ["["] = { gitsigns.prev_hunk, "Previous hunk" },
                ["]"] = { gitsigns.next_hunk, "Next hunk" },
            },
        }

        local objects = {
            ["ih"] = { gitsigns.select_hunk, "Git hunk" },
        }

        local visual = {
            ["ih"] = { gitsigns.select_hunk, "Git hunk" },
        }

        wk.register(keys, { buffer = bufnr })
        wk.register(objects, { mode = "o" })
        wk.register(visual, { mode = "x" })
    end,
})
EOF

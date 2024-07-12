local gitsigns = require("gitsigns")
local utils = require("ambroisie.utils")
local wk = require("which-key")

--- Transform `f` into a function which acts on the current visual selection
local function make_visual(f)
    return function()
        local first = vim.fn.line("v")
        local last = vim.fn.line(".")
        f({ first, last })
    end
end

local function nav_hunk(dir)
    if vim.wo.diff then
        local map = {
            prev = "[c",
            next = "]c",
        }
        vim.cmd.normal({ map[dir], bang = true })
    else
        gitsigns.nav_hunk(dir)
    end
end

gitsigns.setup({
    current_line_blame_opts = {
        -- Show the blame quickly
        delay = 100,
    },
    -- Work-around for https://github.com/lewis6991/gitsigns.nvim/issues/929
    signs_staged_enable = false,
})

local keys = {
    -- Navigation
    ["[c"] = { utils.partial(nav_hunk, "prev"), "Previous hunk/diff" },
    ["]c"] = { utils.partial(nav_hunk, "next"), "Next hunk/diff" },

    -- Commands
    ["<leader>g"] = {
        name = "Git",
        -- Actions
        b = { gitsigns.toggle_current_line_blame, "Toggle blame virtual text" },
        d = { gitsigns.diffthis, "Diff buffer" },
        D = { utils.partial(gitsigns.diffthis, "~"), "Diff buffer against last commit" },
        g = { "<cmd>Git<CR>", "Git status" },
        h = { gitsigns.toggle_deleted, "Show deleted hunks" },
        L = { "<cmd>:sp<CR><C-w>T:Gllog --follow -- %:p<CR>", "Current buffer log" },
        m = { "<Plug>(git-messenger)", "Current line blame" },
        p = { gitsigns.preview_hunk, "Preview hunk" },
        r = { gitsigns.reset_hunk, "Restore hunk" },
        R = { gitsigns.reset_buffer, "Restore buffer" },
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

    ["<leader>g"] = {
        name = "Git",
        p = { gitsigns.preview_hunk, "Preview selection" },
        r = { make_visual(gitsigns.reset_hunk), "Restore selection" },
        s = { make_visual(gitsigns.stage_hunk), "Stage selection" },
        u = { gitsigns.undo_stage_hunk, "Undo stage selection" },
    },
}

wk.register(keys, { buffer = bufnr })
wk.register(objects, { buffer = bufnr, mode = "o" })
wk.register(visual, { buffer = bufnr, mode = "x" })

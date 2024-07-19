local ts_config = require("nvim-treesitter.configs")
local wk = require("which-key")

ts_config.setup({
    highlight = {
        enable = true,
        -- Avoid duplicate highlighting
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            -- Jump to matching text objects
            lookahead = true,
            keymaps = {
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ak"] = "@comment.outer",
                ["aS"] = "@statement.outer",
            },
        },
        move = {
            enable = true,
            -- Add to jump list
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]S"] = "@statement.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[S"] = "@statement.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
})

local motions = {
    ["]m"] = "Next method start",
    ["]M"] = "Next method end",
    ["]S"] = "Next statement start",
    ["]]"] = "Next class start",
    ["]["] = "Next class end",
    ["[m"] = "Previous method start",
    ["[M"] = "Previous method end",
    ["[S"] = "Previous statement start",
    ["[["] = "Previous class start",
    ["[]"] = "Previous class end",
}

local objects = {
    ["aa"] = "a parameter",
    ["ia"] = "inner parameter",
    ["ab"] = "a block",
    ["ib"] = "inner block",
    ["ac"] = "a class",
    ["ic"] = "inner class",
    ["af"] = "a function",
    ["if"] = "inner function",
    ["ak"] = "a comment",
    ["aS"] = "a statement",
}

wk.register(motions, { mode = "n" })
wk.register(objects, { mode = "o" })

lua << EOF
local ts_config = require("nvim-treesitter.configs")
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
            },
        },
    },
})
EOF

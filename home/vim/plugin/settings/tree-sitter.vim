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
})
EOF

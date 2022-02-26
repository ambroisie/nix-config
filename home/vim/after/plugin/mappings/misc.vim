lua << EOF
local wk = require("which-key")

local keys = {
    m = { "<cmd>silent! :make! | :redraw!<CR>", "Run make" },
    ["<leader>"] = { "<cmd>nohls<CR>", "Clear search highlight" },
}

wk.register(keys, { prefix = "<leader>" })
EOF

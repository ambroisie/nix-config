lua << EOF
local wk = require("which-key")

local keys = {
    f = {
        name = "Fuzzy finder",
        b = { "<cmd>Buffers<CR>", "Open buffers" },
        f = { "<cmd>GFiles<CR>", "Git tracked files" },
    },
}

wk.register(keys, { prefix = "<leader>" })
EOF

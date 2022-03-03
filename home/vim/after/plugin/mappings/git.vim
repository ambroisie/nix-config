lua << EOF
local wk = require("which-key")

local keys = {
    d = {
        name = "Merging diff hunks",
        o = { "<cmd>diffget<CR>", "Use this buffer's change", mode="x" },
        p = { "<cmd>diffput<CR>", "Accept other buffer change", mode="x" },
    },
    ["<leader>g"] = {
        name = "Git",
        l = { "<cmd>:sp<CR><C-w>T:Gllog --follow -- %:p<CR>", "Current buffer log" },
        m = { "<Plug>(git-messenger)", "Current line blame" },
    },
}

wk.register(keys)
EOF

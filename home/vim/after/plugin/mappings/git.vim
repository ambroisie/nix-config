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
        d = { "<cmd>Gdiffsplit<CR>", "Current buffer diff" },
        l = { "<cmd>:sp<CR><C-w>T:Gllog --follow -- %:p<CR>", "Current buffer log" },
        m = { "<Plug>(git-messenger)", "Current line blame" },
        s = { "<cmd>Gstatus<CR>", "Status" },
    },
}

wk.register(keys)
EOF

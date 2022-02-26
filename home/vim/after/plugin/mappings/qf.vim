lua << EOF
local wk = require("which-key")

local keys = {
    ["t"] = {
        name = "Toggle",
        f = { "<Plug>(qf_qf_toggle)", "Toggle quickfix list" },
        l = { "<Plug>(qf_loc_toggle)", "Toggle location list" },
    },
}

wk.register(keys, { prefix = "<leader>" })
EOF

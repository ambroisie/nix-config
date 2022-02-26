lua << EOF
local wk = require("which-key")

local keys = {
    ["aa"] = "a parameter",
    ["ia"] = "inner parameter",
    ["ab"] = "a block",
    ["ib"] = "inner block",
    ["ac"] = "a class",
    ["ic"] = "inner class",
    ["af"] = "a function",
    ["if"] = "inner function",
    ["ak"] = "a comment",
}

wk.register(keys, { mode = "o" })
EOF

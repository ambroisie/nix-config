" Show completion menu in all cases, and don't select anything
set completeopt=menu,menuone,noselect

lua << EOF
local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "buffer" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
    },
})
EOF

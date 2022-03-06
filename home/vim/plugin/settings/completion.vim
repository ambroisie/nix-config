" Show completion menu in all cases, and don't select anything
set completeopt=menu,menuone,noselect

lua << EOF
local cmp = require("cmp")

cmp.setup({
    view = {
        entries = "native",
    },
    sources = {
        { name = "path", priority_weight = 110 },
        { name = "nvim_lsp", priority_weight = 100 },
        { name = "nvim_lua", priority_weight = 90 },
        { name = "buffer", max_item_count = 5, priority_weight = 50 },
    },
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
EOF

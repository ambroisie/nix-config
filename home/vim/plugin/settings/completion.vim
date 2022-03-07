" Show completion menu in all cases, and don't select anything
set completeopt=menu,menuone,noselect

lua << EOF
local cmp = require("cmp")
local cmp_under_comparator = require("cmp-under-comparator")

cmp.setup({
    mapping = {
        ["<Down>"] = cmp.mapping({
            i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            c = function(fallback)
                cmp.close()
                vim.schedule(cmp.suspend())
                fallback()
            end,
        }),
        ["<Up>"] = cmp.mapping({
            i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            c = function(fallback)
                cmp.close()
                vim.schedule(cmp.suspend())
                fallback()
            end,
        }),
        ["<Tab>"] = cmp.mapping({
            c = function(fallback)
                if #cmp.core:get_sources() > 0 and not require("cmp.config").is_native_menu() then
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        cmp.complete()
                    end
                else
                    fallback()
                end
            end,
        }),
        ["<S-Tab>"] = cmp.mapping({
            c = function(fallback)
                if #cmp.core:get_sources() > 0 and not require("cmp.config").is_native_menu() then
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        cmp.complete()
                    end
                else
                    fallback()
                end
            end,
        }),
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-5), 
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
        ["<C-e>"] = cmp.mapping.abort(),
    },
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
            cmp_under_comparator.under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
EOF

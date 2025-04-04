-- Show completion menu in all cases, and don't select anything
vim.opt.completeopt = { "menu", "menuone", "noselect" }

local cmp = require("cmp")
local cmp_under_comparator = require("cmp-under-comparator")

cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = function(fallback)
            if vim.snippet.active({ direction = 1 }) then
                vim.snippet.jump(1)
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if vim.snippet.active({ direction = -1 }) then
                vim.snippet.jump(-1)
            else
                fallback()
            end
        end,
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
        { name = "async_path", priority_weight = 110 },
        { name = "nvim_lsp", priority_weight = 100 },
        { name = "nvim_lua", priority_weight = 90 },
        { name = "buffer", max_item_count = 5, priority_weight = 50 },
    },
    sorting = {
        priority_weight = 100,
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
    experimental = {
        ghost_text = true,
    },
})

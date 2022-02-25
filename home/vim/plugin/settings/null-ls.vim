lua << EOF
local null_ls = require("null-ls")
null_ls.setup({
    on_attach = function(client)
        -- Format on save
        if client.resolved_capabilities.document_formatting then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        end
    end,
})
EOF

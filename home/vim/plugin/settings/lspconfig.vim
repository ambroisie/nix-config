lua << EOF
local lsp = require("lspconfig")
local utils = require("ambroisie.utils")

-- C/C++
if utils.is_executable("clangd") then
    lsp.clangd.setup({
        on_attach = utils.on_attach,
    })
end

-- Python
if utils.is_executable("pyright") then
    lsp.pyright.setup({
        on_attach = utils.on_attach,
    })
end

-- Rust
if utils.is_executable("rust-analyzer") then
    lsp.rust_analyzer.setup({
        on_attach = utils.on_attach,
    })
end
EOF

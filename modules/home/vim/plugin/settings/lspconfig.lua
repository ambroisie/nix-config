local lsp = require("ambroisie.lsp")
local utils = require("ambroisie.utils")

-- Diagnostics
vim.diagnostic.config({
    -- Disable virtual test next to affected regions
    virtual_text = false,
    -- Also disable virtual diagnostics under the affected regions
    virtual_lines = false,
    -- Show diagnostics signs
    signs = true,
    -- Underline offending regions
    underline = true,
    -- Do not bother me in the middle of insertion
    update_in_insert = false,
    -- Show highest severity first
    severity_sort = true,
    jump = {
        -- Show float on diagnostic jumps
        float = true,
    },
})

-- Inform servers we are able to do completion, snippets, etc...
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Shared configuration
vim.lsp.config("*", {
    capabilities = capabilities,
    on_attach = lsp.on_attach,
})

-- C/C++
if utils.is_executable("clangd") then
    vim.lsp.enable("clangd")
end

-- Haskell
if utils.is_executable("haskell-language-server-wrapper") then
    vim.lsp.enable("hls")
end

-- Nix
if utils.is_executable("nil") then
    vim.lsp.enable("nil_ls")
end

-- Python
if utils.is_executable("pyright") then
    vim.lsp.enable("pyright")
end

if utils.is_executable("ruff") then
    vim.lsp.enable("ruff")
end

-- Rust
if utils.is_executable("rust-analyzer") then
    vim.lsp.enable("rust_analyzer")
end

-- Shell
if utils.is_executable("bash-language-server") then
    vim.lsp.config("bashls", {
        filetypes = { "bash", "sh", "zsh" },
        settings = {
            bashIde = {
                shfmt = {
                    -- Simplify the code
                    simplifyCode = true,
                    -- Indent switch cases
                    caseIndent = true,
                },
            },
        },
    })
    vim.lsp.enable("bashls")
end

-- Starlark
if utils.is_executable("starpls") then
    vim.lsp.enable("starpls")
end

-- Generic
if utils.is_executable("harper-ls") then
    vim.lsp.enable("harper_ls")
end

if utils.is_executable("typos-lsp") then
    vim.lsp.enable("typos_lsp")
end

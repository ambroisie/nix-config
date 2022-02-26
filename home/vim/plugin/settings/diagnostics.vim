lua << EOF
-- Show LSP diagnostics on virtual lines over affected regions
require("lsp_lines").register_lsp_virtual_lines()

vim.diagnostic.config({
    -- Disable virtual test next to affected regions
    virtual_text = false,
    -- Show diagnostics signs
    signs = true,
    -- Underline offending regions
    underline = true,
    -- Do not bother me in the middle of insertion
    update_in_insert = false,
    -- Show highest severity first
    severity_sort = true,
})
EOF

augroup DiagnosticsHover
    autocmd!
    " Show diagnostics on "hover"
    autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
augroup END

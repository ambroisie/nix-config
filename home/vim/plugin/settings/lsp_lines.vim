lua << EOF
-- Show LSP diagnostics on virtual lines over affected regions
require("lsp_lines").register_lsp_virtual_lines()

-- Disable virtual test next to affected regions
vim.diagnostic.config({
  virtual_text = false,
})
EOF

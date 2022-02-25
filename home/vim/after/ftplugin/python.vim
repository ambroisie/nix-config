" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
null_ls.register({
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
})
EOF

" Change max length of a line to 88 for this buffer to match black's settings
setlocal colorcolumn=88
let b:undo_ftplugin.='|setlocal colorcolumn<'

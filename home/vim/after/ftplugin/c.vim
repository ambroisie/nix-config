" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
null_ls.register({
    null_ls.builtins.formatting.clang_format,
})
EOF

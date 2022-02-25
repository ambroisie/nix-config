" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
null_ls.register({
    null_ls.builtins.formatting.brittany,
})
EOF

" Use a small indentation value on Haskell files
setlocal shiftwidth=2
let b:undo_ftplugin.='|setlocal shiftwidth<'

" Change max length of a line to 100 for this buffer to match official guidelines
setlocal colorcolumn=100
let b:undo_ftplugin.='|setlocal colorcolumn<'

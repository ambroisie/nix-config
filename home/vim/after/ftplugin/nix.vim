" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
local utils = require("ambroisie.utils")

null_ls.register({
    null_ls.builtins.formatting.nixpkgs_fmt.with({
        -- Only used if available
        condition = utils.is_executable_condition("nixpkgs-fmt"),
    }),
})
EOF

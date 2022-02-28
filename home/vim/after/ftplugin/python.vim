" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
local utils = require("ambroisie.utils")

null_ls.register({
    null_ls.builtins.diagnostics.flake8.with({
        -- Only used if available
        condition = utils.is_executable_condition("flake8"),
    }),
    null_ls.builtins.diagnostics.mypy.with({
        -- Only used if available
        condition = utils.is_executable_condition("mypy"),
    }),
    null_ls.builtins.diagnostics.pylint.with({
        -- Only used if available
        condition = utils.is_executable_condition("pylint"),
    })
    null_ls.builtins.formatting.black.with({
        extra_args = { "--fast" },
        -- Only used if available
        condition = utils.is_executable_condition("black"),
    }),
    null_ls.builtins.formatting.isort.with({
        -- Only used if available
        condition = utils.is_executable_condition("isort"),
    }),
})
EOF

" Change max length of a line to 88 for this buffer to match black's settings
setlocal colorcolumn=88
let b:undo_ftplugin.='|setlocal colorcolumn<'

" Create the `b:undo_ftplugin` variable if it doesn't exist
call ftplugined#check_undo_ft()

" Set-up LSP, linters, formatters
lua << EOF
local null_ls = require("null-ls")
local utils = require("ambroisie.utils")

null_ls.register({
    null_ls.builtins.diagnostics.shellcheck.with({
        -- Show error code in message
        diagnostics_format = "[#{c}] #{m}",
        -- Require explicit empty string test, use bash dialect
        extra_args = { "-s", "bash", "-o", "avoid-nullary-conditions" },
        -- Only used if available
        condition = utils.is_executable_condition("shellcheck"),
    }),
    null_ls.builtins.formatting.shfmt.with({
        -- Indent with 4 spaces, simplify the code, indent switch cases,
        -- add space after redirection, use bash dialect
        extra_args = { "-i", "4", "-s", "-ci", "-sr", "-ln", "bash" },
        -- Only used if available
        condition = utils.is_executable_condition("shfmt"),
    }),
})
EOF

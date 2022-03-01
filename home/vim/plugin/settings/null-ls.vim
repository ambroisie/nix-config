lua << EOF
local null_ls = require("null-ls")
local utils = require("ambroisie.utils")

null_ls.setup({
    on_attach = function(client)
        -- Format on save
        if client.resolved_capabilities.document_formatting then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        end
    end,
})

-- C, C++
null_ls.register({
    null_ls.builtins.formatting.clang_format.with({
        -- Only used if available
        condition = utils.is_executable_condition("clang-format"),
    }),
})

-- Haskell
null_ls.register({
    null_ls.builtins.formatting.brittany.with({
        -- Only used if available
        condition = utils.is_executable_condition("brittany"),
    }),
})

-- Nix
null_ls.register({
    null_ls.builtins.formatting.nixpkgs_fmt.with({
        -- Only used if available
        condition = utils.is_executable_condition("nixpkgs-fmt"),
    }),
})

-- Python
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
    }),
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


-- Shell (non-POSIX)
null_ls.register({
    null_ls.builtins.diagnostics.shellcheck.with({
        -- Show error code in message
        diagnostics_format = "[#{c}] #{m}",
        -- Require explicit empty string test, use bash dialect
        extra_args = { "-s", "bash", "-o", "avoid-nullary-conditions" },
        -- Restrict to bash and zsh
        filetypes = { "bash", "zsh" },
        -- Only used if available
        condition = utils.is_executable_condition("shellcheck"),
    }),
    null_ls.builtins.formatting.shfmt.with({
        -- Indent with 4 spaces, simplify the code, indent switch cases,
        -- add space after redirection, use bash dialect
        extra_args = { "-i", "4", "-s", "-ci", "-sr", "-ln", "bash" },
        -- Restrict to bash and zsh
        filetypes = { "bash", "zsh" },
        -- Only used if available
        condition = utils.is_executable_condition("shfmt"),
    }),
})

-- Shell (POSIX)
null_ls.register({
    null_ls.builtins.diagnostics.shellcheck.with({
        -- Show error code in message
        diagnostics_format = "[#{c}] #{m}",
        -- Require explicit empty string test
        extra_args = { "-o", "avoid-nullary-conditions" },
        -- Restrict to POSIX sh
        filetypes = { "sh" },
        -- Only used if available
        condition = utils.is_executable_condition("shellcheck"),
    }),
    null_ls.builtins.formatting.shfmt.with({
        -- Indent with 4 spaces, simplify the code, indent switch cases,
        -- add space after redirection, use POSIX
        extra_args = { "-i", "4", "-s", "-ci", "-sr", "-ln", "posix" },
        -- Only used if available
        condition = utils.is_executable_condition("shfmt"),
    }),
})
EOF

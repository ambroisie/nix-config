local null_ls = require("null-ls")
local lsp = require("ambroisie.lsp")
local utils = require("ambroisie.utils")

null_ls.setup({
    on_attach = lsp.on_attach,
})

-- Bazel
null_ls.register({
    null_ls.builtins.diagnostics.buildifier.with({
        -- Only used if available
        condition = utils.is_executable_condition("buildifier"),
    }),
    null_ls.builtins.formatting.buildifier.with({
        -- Only used if available
        condition = utils.is_executable_condition("buildifier"),
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
    null_ls.builtins.formatting.shfmt.with({
        -- Indent with 4 spaces, simplify the code, indent switch cases,
        -- add space after redirection, use POSIX
        extra_args = { "-i", "4", "-s", "-ci", "-sr", "-ln", "posix" },
        -- Restrict to POSIX sh
        filetypes = { "sh" },
        -- Only used if available
        condition = utils.is_executable_condition("shfmt"),
    }),
})

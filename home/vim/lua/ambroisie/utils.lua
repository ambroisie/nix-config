local M = {}

--- checks if a given command is executable
---@param cmd string? command to check
---@return boolean executable
M.is_executable = function(cmd)
    return cmd and vim.fn.executable(cmd) == 1
end

--- return a function that checks if a given command is executable
---@param cmd string? command to check
---@return fun(cmd: string): boolean executable
M.is_executable_condition = function(cmd)
    return function() return M.is_executable(cmd) end
end

-- list all active LSP clients for current buffer
-- @param bufnr int? buffer number
-- @return table all active LSP client names
M.list_lsp_clients = function(bufnr)
    local clients = vim.lsp.buf_get_clients(bufnr)
    local names = {}

    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end

    return names
end

-- shared LSP configuration callback
-- @param client native client configuration
-- @param bufnr int? buffer number of the attched client
M.on_attach = function(client, bufnr)
    -- Diagnostics
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

    vim.cmd([[
        augroup DiagnosticsHover
            autocmd! * <buffer>
            " Show diagnostics on "hover"
            autocmd CursorHold,CursorHoldI <buffer> lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
        augroup END
    ]])

    -- Format on save
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
        ]])
    end

    -- Mappings
    local wk = require("which-key")

    local keys = {
        K = { vim.lsp.buf.hover, "Show symbol information" },
        ["gd"] = { vim.lsp.buf.definition, "Go to definition" },
        ["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
        ["gi"] = { vim.lsp.buf.implementation, "Go to implementation" },
        ["gr"] = { vim.lsp.buf.references, "List all references" },

        ["<leader>c"] = {
            name = "Code",
            a = { vim.lsp.buf.code_action, "Code actions" },
            r = { vim.lsp.buf.rename, "Rename symbol" },
            s = { vim.lsp.buf.signature_help, "Show signature" },
            t = { vim.lsp.buf.type_definition, "Go to type definition" },
        },
    }

    wk.register(keys, { buffer = bufnr })
end

return M

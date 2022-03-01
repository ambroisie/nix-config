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

-- shared LSP configuration callback
-- @param client native client configuration
-- @param bufnr int? buffer number of the attched client
M.on_attach = function(client, bufnr)
    -- Format on save
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
        ]])
    end
end

return M

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

return M

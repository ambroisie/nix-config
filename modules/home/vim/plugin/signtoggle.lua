local signtoggle = vim.api.nvim_create_augroup("signtoggle", { clear = true })

-- Only show sign column for the currently focused buffer
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
    pattern = "*",
    group = signtoggle,
    callback = function()
        vim.opt.signcolumn = "yes"
    end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
    pattern = "*",
    group = signtoggle,
    callback = function()
        vim.opt.signcolumn = "no"
    end,
})

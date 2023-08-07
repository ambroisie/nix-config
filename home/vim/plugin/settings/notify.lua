local notify = require("notify")
local lsp_notify = require("lsp-notify")

notify.setup({
    icons = {
        DEBUG = "D",
        ERROR = "E",
        INFO = "I",
        TRACE = "T",
        WARN = "W",
    },
    stages = "slide",
})

vim.notify = notify

lsp_notify.setup({})

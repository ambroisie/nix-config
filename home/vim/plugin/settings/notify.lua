local notify = require("notify")

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

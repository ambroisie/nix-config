local ts_config = require("nvim-treesitter.configs")
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move = require("nvim-treesitter-textobjects.move")
local utils = require("ambroisie.utils")
local wk = require("which-key")

local function select_textobject(query)
    return utils.partial(ts_select.select_textobject, query)
end

local function goto_next_start(query)
    return utils.partial(ts_move.goto_next_start, query)
end
local function goto_next_end(query)
    return utils.partial(ts_move.goto_next_end, query)
end
local function goto_previous_start(query)
    return utils.partial(ts_move.goto_previous_start, query)
end
local function goto_previous_end(query)
    return utils.partial(ts_move.goto_previous_end, query)
end

local objects = {
    mode = { "x", "o" },
    { "aa", select_textobject("@parameter.outer"), desc = "a parameter" },
    { "ia", select_textobject("@parameter.inner"), desc = "inner parameter" },
    { "ab", select_textobject("@block.outer"), desc = "a block" },
    { "ib", select_textobject("@block.inner"), desc = "inner block" },
    { "ac", select_textobject("@class.outer"), desc = "a class" },
    { "ic", select_textobject("@class.inner"), desc = "inner class" },
    { "af", select_textobject("@function.outer"), desc = "a function" },
    { "if", select_textobject("@function.inner"), desc = "inner function" },
    { "ak", select_textobject("@comment.outer"), desc = "a comment" },
    { "aS", select_textobject("@statement.outer"), desc = "a statement" },
}
local moves = {
    mode = { "n", "x", "o" },
    -- Next start
    { "]m", goto_next_start("@function.outer"), desc = "Next method start" },
    { "]S", goto_next_start("@statement.outer"), desc = "Next statement start" },
    { "]]", goto_next_start("@class.outer"), desc = "Next class start" },
    -- Next end
    { "]M", goto_next_end("@function.outer"), desc = "Next method end" },
    { "][", goto_next_end("@class.outer"), desc = "Next class end" },
    -- Previous start
    { "[m", goto_previous_start("@function.outer"), desc = "Previous method start" },
    { "[S", goto_previous_start("@statement.outer"), desc = "Previous statement start" },
    { "[[", goto_previous_start("@class.outer"), desc = "Previous class start" },
    -- Previous end
    { "[M", goto_previous_end("@function.outer"), desc = "Previous method end" },
    { "[]", goto_previous_end("@class.outer"), desc = "Previous class end" },
}
wk.add(objects)
wk.add(moves)

ts_config.setup({
    highlight = {
        enable = true,
        -- Avoid duplicate highlighting
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
})

require("nvim-treesitter-textobjects").setup({
    select = {
        -- Jump to matching text objects
        lookahead = true,
    },
    move = {
        -- Add to jump list
        set_jumps = true,
    },
})

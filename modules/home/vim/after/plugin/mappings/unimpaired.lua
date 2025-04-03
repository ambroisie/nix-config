local wk = require("which-key")

local lsp = require("ambroisie.lsp")

local keys = {
    -- Previous
    { "[", group = "Previous" },
    -- Edition and navigation mappings
    { "[<space>", desc = "Insert blank line above" },
    { "[<C-L>", desc = "Previous location list file" },
    { "[<C-Q>", desc = "Previous quickfix list file" },
    { "[<C-T>", desc = "Previous tag in preview window" },
    { "[a", desc = "Previous argument" },
    { "[A", desc = "First argument" },
    { "[b", desc = "Previous buffer" },
    { "[B", desc = "First buffer" },
    { "[e", desc = "Exchange previous line" },
    { "[f", desc = "Previous file in directory" },
    { "[l", desc = "Previous location list entry" },
    { "[L", desc = "First Location list entry" },
    { "[n", desc = "Previous conflict marker/diff hunk" },
    { "[p", desc = "Paste line above" },
    { "[P", desc = "Paste line above" },
    { "[q", desc = "Previous quickfix list entry" },
    { "[Q", desc = "First quickfix list entry" },
    { "[t", desc = "Previous matching tag" },
    { "[T", desc = "First matching tag" },
    { "[z", desc = "Previous fold" },
    -- Encoding
    { "[C", desc = "C string encode" },
    { "[u", desc = "URL encode" },
    { "[x", desc = "XML encode" },
    { "[y", desc = "C string encode" },

    -- Next
    { "]", group = "Next" },
    -- Edition and navigation mappings
    { "]<space>", desc = "Insert blank line below" },
    { "]<C-L>", desc = "Next location list file" },
    { "]<C-Q>", desc = "Next quickfix list file" },
    { "]<C-T>", desc = "Next tag in preview window" },
    { "]a", desc = "Next argument" },
    { "]A", desc = "Last argument" },
    { "]b", desc = "Next buffer" },
    { "]B", desc = "Last buffer" },
    { "]e", desc = "Exchange next line" },
    { "]f", desc = "Next file in directory" },
    { "]l", desc = "Next location list entry" },
    { "]L", desc = "Last Location list entry" },
    { "]n", desc = "Next conflict marker/diff hunk" },
    { "]p", desc = "Paste line below" },
    { "]P", desc = "Paste line below" },
    { "]q", desc = "Next quickfix list entry" },
    { "]Q", desc = "Last quickfix list entry" },
    { "]t", desc = "Next matching tag" },
    { "]T", desc = "Last matching tag" },
    { "]z", desc = "Next fold" },
    -- Decoding
    { "]C", desc = "C string decode" },
    { "]u", desc = "URL decode" },
    { "]x", desc = "XML decode" },
    { "]y", desc = "C string decode" },

    -- Enable option
    { "[o", group = "Enable option" },
    { "[ob", desc = "Light background" },
    { "[oc", desc = "Cursor line" },
    { "[od", desc = "Diff" },
    { "[of", "<cmd>FormatEnable<CR>", desc = "LSP Formatting" },
    { "[oh", desc = "Search high-lighting" },
    { "[oi", desc = "Case insensitive search" },
    { "[ol", desc = "List mode" },
    { "[on", desc = "Line numbers" },
    { "[or", desc = "Relative line numbers" },
    { "[op", "<cmd>lwindow<CR>", desc = "Location list" },
    { "[oq", "<cmd>cwindow<CR>", desc = "Quickfix list" },
    { "[ou", desc = "Cursor column" },
    { "[ov", desc = "Virtual editing" },
    { "[ow", desc = "Text wrapping" },
    { "[ox", desc = "Cursor line and column" },
    { "[oz", desc = "Spell checking" },

    -- Disable option
    { "]o", group = "Disable option" },
    { "]ob", desc = "Light background" },
    { "]oc", desc = "Cursor line" },
    { "]od", desc = "Diff" },
    { "]of", "<cmd>FormatDisable<CR>", desc = "LSP Formatting" },
    { "]oh", desc = "Search high-lighting" },
    { "]oi", desc = "Case insensitive search" },
    { "]ol", desc = "List mode" },
    { "]on", desc = "Line numbers" },
    { "]op", "<cmd>lclose<CR>", desc = "Location list" },
    { "]oq", "<cmd>cclose<CR>", desc = "Quickfix list" },
    { "]or", desc = "Relative line numbers" },
    { "]ou", desc = "Cursor column" },
    { "]ov", desc = "Virtual editing" },
    { "]ow", desc = "Text wrapping" },
    { "]ox", desc = "Cursor line and column" },
    { "]oz", desc = "Spell checking" },

    -- Toggle option
    { "yo", group = "Toggle option" },
    { "yob", desc = "Light background" },
    { "yoc", desc = "Cursor line" },
    { "yod", desc = "Diff" },
    { "yof", "<cmd>FormatToggle<CR>", desc = "LSP Formatting" },
    { "yoh", desc = "Search high-lighting" },
    { "yoi", desc = "Case insensitive search" },
    { "yol", desc = "List mode" },
    { "yon", desc = "Line numbers" },
    { "yop", "<Plug>(qf_loc_toggle)", desc = "Location list" },
    { "yoq", "<Plug>(qf_qf_toggle)", desc = "Quickfix list" },
    { "yor", desc = "Relative line numbers" },
    { "you", desc = "Cursor column" },
    { "yov", desc = "Virtual editing" },
    { "yow", desc = "Text wrapping" },
    { "yox", desc = "Cursor line and column" },
    { "yoz", desc = "Spell checking" },
}

wk.add(keys)

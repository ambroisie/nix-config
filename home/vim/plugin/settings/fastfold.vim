lua << EOF
-- Intercept all fold commands
vim.g.fastfold_fold_command_suffixes = {
    "x", "X", "a", "A", "o", "O", "c", "C", "r", "R", "m", "M", "i", "n", "N",
}
EOF

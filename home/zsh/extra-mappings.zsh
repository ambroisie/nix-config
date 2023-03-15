# shellcheck disable=2154

# The expression: (( ${+terminfo} )) should never fail, but does if we
# don't have a tty, perhaps due to a bug in the zsh/terminfo module.
if [[ "$TERM" != emacs ]] && (( ${+terminfo} )) 2>/dev/null; then
    # Fix delete key not working
    ((${+terminfo[kdch1]})) && bindkey -- "${terminfo[kdch1]}" delete-char
    # Enable Shift-Tab to go backwards in completion list
    ((${+terminfo[kcbt]})) && bindkey -- "${terminfo[kcbt]}" reverse-menu-complete
fi

# Fix Ctrl+u killing from the cursor instead of the whole line
bindkey '^u' backward-kill-line

# Use Ctrl+x-(Ctrl+)e to edit the current command line in VISUAL/EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# Enable Shift-Tab to go backwards in completion list
bindkey '^[[Z' reverse-menu-complete

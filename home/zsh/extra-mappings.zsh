# shellcheck disable=2154

# Fix Ctrl+u killing from the cursor instead of the whole line
bindkey '^u' backward-kill-line

# Use Ctrl+x-(Ctrl+)e to edit the current command line in VISUAL/EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# The expression: (( ${+terminfo} )) should never fail, but does if we
# don't have a tty, perhaps due to a bug in the zsh/terminfo module.
if ! { [ "$TERM" != emacs ] && (( ${+terminfo} )) 2>/dev/null; }; then
    return
fi

# Fix delete key not working
if [ -n "${terminfo[kdch1]}" ]; then
    bindkey -M emacs "${terminfo[kdch1]}" delete-char
    bindkey -M viins "${terminfo[kdch1]}" delete-char
    bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
    bindkey -M emacs "^[[3~" delete-char
    bindkey -M viins "^[[3~" delete-char
    bindkey -M vicmd "^[[3~" delete-char

    bindkey -M emacs "^[3;5~" delete-char
    bindkey -M viins "^[3;5~" delete-char
    bindkey -M vicmd "^[3;5~" delete-char
fi

# Enable Shift-Tab to go backwards in completion list
if [ -n "${terminfo[kcbt]}" ]; then
    bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
    bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
    bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
else
    bindkey -M emacs '^[[Z' reverse-menu-complete
    bindkey -M viins '^[[Z' reverse-menu-complete
    bindkey -M vicmd '^[[Z' reverse-menu-complete
fi

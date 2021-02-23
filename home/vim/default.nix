{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    # All the aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Theming
      lightline-vim # Fancy status bar
      onedark-vim # Nice dark theme

      # tpope essentials
      vim-commentary # Easy comments
      vim-eunuch # UNIX integrations
      vim-git # Sane git syntax files
      vim-repeat # Enanche '.' for plugins
      vim-rsi # Readline mappings
      vim-surround # Deal with pairs
      vim-unimpaired # Some ex command mappings
      vim-vinegar # Better netrw

      # Languages
      rust-vim
      vim-beancount
      vim-jsonnet
      vim-nix
      vim-pandoc
      vim-pandoc-syntax
      vim-toml

      # General enhancements
      fastfold # Better folding
      vim-qf # Better quick-fix list

      # LSP and linting
      ale # Asynchronous Linting Engine
      lightline-ale # Status bar integration
    ];
  };
}

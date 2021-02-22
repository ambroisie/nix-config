{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    # All the aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };
}

{ ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./documentation.nix
    ./flameshot.nix
    ./git
    ./gpg.nix
    ./htop.nix
    ./jq.nix
    ./packages.nix
    ./pager.nix
    ./secrets # Home-manager specific secrets
    ./ssh.nix
    ./terminal
    ./tmux.nix
    ./udiskie.nix
    ./vim
    ./wm
    ./x
    ./xdg.nix
    ./zathura.nix
    ./zsh
  ];

  # First sane reproducible version
  home.stateVersion = "20.09";

  # Who am I?
  home.username = "ambroisie";
}

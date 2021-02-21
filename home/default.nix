{ ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./documentation.nix
    ./git
    ./htop.nix
    ./jq.nix
    ./packages.nix
    ./pager.nix
    ./secrets # Home-manager specific secrets
    ./ssh.nix
    ./tmux.nix
    ./zsh
  ];
}

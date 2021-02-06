# Common packages
{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    git-crypt
    mosh
    vim
    wget
  ];

  nixpkgs.config.allowUnfree = true; # Because I don't care *that* much.
}

# Common modules
{ ... }:

{
  imports = [
    ./ergodox.nix
    ./language.nix
    ./media.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./users.nix
  ];
}

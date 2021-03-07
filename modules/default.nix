# Common modules
{ ... }:

{
  imports = [
    ./ergodox.nix
    ./language.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./users.nix
  ];
}

# Common modules
{ ... }:

{
  imports = [
    ./language.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./users.nix
  ];
}

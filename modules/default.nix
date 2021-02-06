# Common modules
{ ... }:

{
  imports = [
    ./language.nix
    ./nix.nix
    ./packages.nix
    ./users.nix
  ];
}

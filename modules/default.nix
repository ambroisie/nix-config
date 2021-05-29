# Common modules
{ ... }:

{
  imports = [
    ./documentation.nix
    ./hardware
    ./home.nix
    ./language.nix
    ./nix.nix
    ./packages.nix
    ./services
    ./system
    ./users.nix
  ];
}

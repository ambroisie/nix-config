# Common modules
{ ... }:

{
  imports = [
    ./hardware
    ./home.nix
    ./services
    ./system
  ];
}

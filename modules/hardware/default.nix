# Hardware-related modules
{ ... }:

{
  imports = [
    ./bluetooth.nix
    ./ergodox.nix
    ./networking.nix
  ];
}

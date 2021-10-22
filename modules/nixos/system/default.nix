# System-related modules
{ ... }:

{
  imports = [
    ./boot
    ./docker
    ./documentation
    ./language
    ./nix
    ./packages
    ./persist
    ./podman
    ./polkit
    ./printing
    ./users
  ];
}

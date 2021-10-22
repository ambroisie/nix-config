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
    ./printing
    ./users
  ];
}

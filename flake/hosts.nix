# Define `hosts.{darwin,home,nixos}` options for consumption in other modules
{ lib, ... }:
let
  mkHostsOption = description: lib.mkOption {
    inherit description;
    type = with lib.types; attrsOf str;
    default = { };
    example = { name = "x86_64-linux"; };
  };
in
{
  options = {
    hosts = {
      darwin = mkHostsOption "Darwin hosts";

      homes = mkHostsOption "Home Manager hosts";

      nixos = mkHostsOption "NixOS hosts";
    };
  };
}

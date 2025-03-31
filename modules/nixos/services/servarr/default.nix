# The total autonomous media delivery system.
# Relevant link [1].
#
# [1]: https://youtu.be/I26Ql-uX6AM
{ lib, ... }:
{
  imports = [
    ./bazarr.nix
    (import ./starr.nix "lidarr")
    (import ./starr.nix "radarr")
    (import ./starr.nix "readarr")
    (import ./starr.nix "sonarr")
  ];

  options.my.services.servarr = {
    enableAll = lib.mkEnableOption "media automation suite";
  };
}

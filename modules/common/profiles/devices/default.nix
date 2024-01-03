{ config, lib, _class, ... }:
let
  cfg = config.my.profiles.devices;
in
{
  options.my.profiles.devices = with lib; {
    enable = mkEnableOption "devices profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (_class == "nixos") {
      my.hardware = {
        ergodox.enable = true;

        trackball.enable = true;
      };

      # MTP devices auto-mount via file explorers
      services.gvfs.enable = true;
    })
  ]);
}

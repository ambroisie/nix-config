{ config, lib, _class, ... }:
let
  cfg = config.my.profiles.bluetooth;
in
{
  options.my.profiles.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (_class == "homeManager") {
      my.home.bluetooth.enable = true;
    })

    (lib.optionalAttrs (_class == "nixos") {
      my.hardware.bluetooth.enable = true;
    })
  ]);
}

{ config, lib, _class, ... }:
let
  cfg = config.my.profiles.laptop;
in
{
  options.my.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (_class == "homeManager") {
      # Enable battery notifications
      my.home.power-alert.enable = true;
    })

    (lib.optionalAttrs (_class == "nixos") {
      # Enable touchpad support
      services.libinput.enable = true;

      # Enable TLP power management
      my.services.tlp.enable = true;

      # Enable upower power management
      my.hardware.upower.enable = true;
    })
  ]);
}

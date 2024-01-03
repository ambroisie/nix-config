{ config, lib, _class, ... }:
let
  cfg = config.my.profiles.gtk;
in
{
  options.my.profiles.gtk = with lib; {
    enable = mkEnableOption "gtk profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (_class == "homeManager") {
      # GTK theme configuration
      my.home.gtk.enable = true;
    })

    (lib.optionalAttrs (_class == "nixos") {
      # Allow setting GTK configuration using home-manager
      programs.dconf.enable = true;
    })
  ]);
}

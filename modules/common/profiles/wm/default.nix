{ config, lib, _class, ... }:
let
  cfg = config.my.profiles.wm;

  applyWm = wm: configs: lib.mkIf (cfg.windowManager == wm) (lib.my.merge configs);
in
{
  options.my.profiles.wm = with lib; {
    windowManager = mkOption {
      type = with types; nullOr (enum [ "i3" ]);
      default = null;
      example = "i3";
      description = "Which window manager to use";
    };
  };

  config = lib.mkMerge [
    (applyWm "i3" [
      (lib.optionalAttrs (_class == "homeManager") {
        # i3 settings
        my.home.wm.windowManager = "i3";
        # Screenshot tool
        my.home.flameshot.enable = true;
        # Auto disk mounter
        my.home.udiskie.enable = true;
      })

      (lib.optionalAttrs (_class == "nixos") {
        # Enable i3
        services.xserver.windowManager.i3.enable = true;
        # udiskie fails if it can't find this dbus service
        services.udisks2.enable = true;
        # Ensure i3lock can actually unlock the session
        security.pam.services.i3lock.enable = true;
      })
    ])
  ];
}

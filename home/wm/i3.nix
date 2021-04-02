{ config, lib, ... }:
let
  isEnabled = config.my.home.wm.windowManager == "i3";
in
{
  config = lib.mkIf isEnabled {
    xsession.windowManager.i3 = {
      enable = true;

      config = {
        modifier = "Mod4"; # `Super` key
      };
    };
  };
}

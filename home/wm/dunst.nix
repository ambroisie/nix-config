{ config, lib, ... }:
let
  cfg = config.my.home.wm.dunst;
in
{
  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
    };
  };
}

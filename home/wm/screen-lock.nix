{ config, lib, ... }:
let
  cfg = config.my.home.wm.screen-lock;
in
{
  config = lib.mkIf cfg.enable {
    services.screen-locker = {
      enable = true;

      inactiveInterval = cfg.timeout;

      lockCmd = cfg.command;
    };
  };
}

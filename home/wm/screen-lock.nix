{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.wm.screen-lock;
in
{
  config = lib.mkIf cfg.enable {
    services.screen-locker = {
      enable = true;

      inactiveInterval = cfg.timeout;

      lockCmd = cfg.command;

      xautolockExtraOptions = lib.optionals cfg.cornerLock.enable [
        # Mouse corners: instant lock on upper-left, never lock on lower-right
        "-cornerdelay"
        "${toString cfg.cornerLock.delay}"
        "-cornerredelay"
        "${toString cfg.cornerLock.delay}"
        "-corners"
        "+00-"
      ] ++ lib.optionals cfg.notify [
        "-notify"
        "5"
        "-notifier"
        ''"${pkgs.libnotify}/bin/notify-send -u critical -t 5000 -- 'Locking in 5 seconds'"''
      ];
    };
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.wm.screen-lock;

  notificationCmd =
    let
      duration = toString (cfg.notify.delay * 1000);
      notifyCmd = "${lib.getExe pkgs.libnotify} -u critical -t ${duration}";
    in
    # Needs to be surrounded by quotes for systemd to launch it correctly
    ''"${notifyCmd} -- 'Locking in ${toString cfg.notify.delay} seconds'"'';
in
{
  config = lib.mkIf cfg.enable {
    services.screen-locker = {
      enable = true;

      inactiveInterval = cfg.timeout;

      lockCmd = cfg.command;

      xautolock = {
        extraOptions = lib.optionals cfg.notify.enable [
          "-notify"
          "${toString cfg.notify.delay}"
          "-notifier"
          notificationCmd
        ];
      };
    };
  };
}

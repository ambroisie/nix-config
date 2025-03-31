# The total autonomous media delivery system.
# Relevant link [1].
#
# [1]: https://youtu.be/I26Ql-uX6AM
{ config, lib, ... }:
let
  cfg = config.my.services.servarr;

  ports = {
    bazarr = 6767;
    lidarr = 8686;
    radarr = 7878;
    readarr = 8787;
    sonarr = 8989;
  };

  mkService = service: {
    services.${service} = {
      enable = true;
      group = "media";
    };
    # Set-up media group
    users.groups.media = { };
  };

  mkRedirection = service: {
    my.services.nginx.virtualHosts = {
      ${service} = {
        port = ports.${service};
      };
    };
  };

  mkFail2Ban = service: lib.mkIf cfg.${service}.enable {
    services.fail2ban.jails = {
      ${service} = ''
        enabled = true
        filter = ${service}
        action = iptables-allports
      '';
    };

    environment.etc = {
      "fail2ban/filter.d/${service}.conf".text = ''
        [Definition]
        failregex = ^.*\|Warn\|Auth\|Auth-Failure ip <HOST> username .*$
        journalmatch = _SYSTEMD_UNIT=${service}.service
      '';
    };
  };

  mkFullConfig = service: lib.mkIf cfg.${service}.enable (lib.mkMerge [
    (mkService service)
    (mkRedirection service)
  ]);
in
{
  options.my.services.servarr = {
    enableAll = lib.mkEnableOption "media automation suite";

    bazarr = {
      enable = lib.mkEnableOption "Bazarr" // { default = cfg.enableAll; };;
    };

    lidarr = {
      enable = lib.mkEnableOption "Lidarr" // { default = cfg.enableAll; };
    };

    radarr = {
      enable = lib.mkEnableOption "Radarr" // { default = cfg.enableAll; };
    };

    readarr = {
      enable = lib.mkEnableOption "Readarr" // { default = cfg.enableAll; };
    };

    sonarr = {
      enable = lib.mkEnableOption "Sonarr" // { default = cfg.enableAll; };
    };
  };

  config = (lib.mkMerge [
    # Bazarr does not log authentication failures...
    (mkFullConfig "bazarr")
    # Lidarr for music
    (mkFullConfig "lidarr")
    (mkFail2Ban "lidarr")
    # Radarr for movies
    (mkFullConfig "radarr")
    (mkFail2Ban "radarr")
    # Readarr for books
    (mkFullConfig "readarr")
    (mkFail2Ban "readarr")
    # Sonarr for shows
    (mkFullConfig "sonarr")
    (mkFail2Ban "sonarr")
  ]);
}

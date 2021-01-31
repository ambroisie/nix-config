# The total autonomous media delivery system.
# Relevant link [1].
#
# [1]: https://youtu.be/I26Ql-uX6AM
{ config, lib, ... }:
let
  cfg = config.my.services.pirate;
  domain = config.networking.domain;

  ports = {
    sonarr = 8989;
    radarr = 7878;
    bazarr = 6767;
  };

  managers = with lib.attrsets;
    (mapAttrs
      (_: _: {
        enable = true;
        group = "media";
      })
      ports);

  redirections = with lib.attrsets;
    (mapAttrs'
      (service: port: nameValuePair "${service}.${domain}" {
        forceSSL = true;
        useACMEHost = "${domain}";

        locations."/".proxyPass = "http://localhost:${builtins.toString port}/";
      })
      ports);
in
{
  options.my.services.pirate = {
    enable = lib.mkEnableOption "Media automation";
  };

  config = lib.mkIf cfg.enable {
    services = managers // { nginx.virtualHosts = redirections; };
  };
}

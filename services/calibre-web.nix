{ config, lib, ... }:
let
  cfg = config.my.services.calibre-web;
  domain = config.networking.domain;
  calibreDomain = "library.${domain}";
in
{
  options.my.services.calibre-web = with lib; {
    enable = mkEnableOption "Calibre-web server";

    port = mkOption {
      type = types.port;
      default = 8083;
      example = 8080;
      description = "Internal port for webui";
    };

    libraryPath = mkOption {
      type = with types; either path str;
      example = /data/media/library;
      description = "Path to the Calibre library to use";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      calibre-web = {
        image = "technosoft2000/calibre-web";
        volumes = [
          "${cfg.libraryPath}:/books"
        ];
        ports = [
          "127.0.0.1:${toString cfg.port}:8083"
        ];
        environment = {
          # NOTE: should be configurable
          SET_CONTAINER_TIMEZONE = "true";
          CONTAINER_TIMEZONE = "Europe/Paris";
          # Use 'media' group id
          PDGID = toString config.users.groups.media.gid;
        };
      };
    };

    services.nginx.virtualHosts."${calibreDomain}" = {
      forceSSL = true;
      useACMEHost = domain;

      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}/";
    };

    my.services.backup = {
      paths = [
        cfg.libraryPath
      ];
    };
  };
}

# Small seedbox setup.
#
# Inspired by [1]
#
# [1]: https://github.com/delroth/infra.delroth.net/blob/master/roles/seedbox.nix
{ config, lib, ... }:
let
  cfg = config.my.services.transmission;

  domain = config.networking.domain;
  webuiDomain = "transmission.${domain}";

  transmissionRpcPort = 9091;
  transmissionPeerPort = 30251;

  downloadBase = "/data/downloads/"; # NOTE: to be excluded from backups
in
{
  options.my.services.transmission = with lib; {
    enable = mkEnableOption "Transmission torrent client";
    username = mkOption {
      type = types.str;
      default = "Ambroisie";
      example = "username";
      description = "Name of the transmission RPC user";
    };
    password = mkOption {
      type = types.str;
      example = "password";
      description = "Password of the transmission RPC user";
    };
  };

  config = lib.mkIf cfg.enable {
    services.transmission = {
      enable = true;
      group = "media";

      settings = {
        download-dir = "${downloadBase}/complete";
        incomplete-dir = "${downloadBase}/incomplete";
        umask = 0; # Make it world-writeable

        peer-port = transmissionPeerPort;

        rpc-enabled = true;
        rpc-port = transmissionRpcPort;
        rpc-authentication-required = true;

        rpc-username = cfg.username;
        rpc-password = cfg.password; # Insecure, but I don't care.

        # Proxied behind Nginx.
        rpc-whitelist-enabled = true;
        rpc-whitelist = "127.0.0.1";
      };
    };

    # Default transmission webui, I prefer combustion but its development
    # seems to have stalled
    services.nginx.virtualHosts."${webuiDomain}" = {
      forceSSL = true;
      useACMEHost = domain;

      locations."/".proxyPass = "http://localhost:${toString transmissionRpcPort}";
    };

    networking.firewall = {
      allowedTCPPorts = [ transmissionPeerPort ];
      allowedUDPPorts = [ transmissionPeerPort ];
    };
  };
}

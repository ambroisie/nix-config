# Matrix homeserver setup, using different endpoints for federation and client
# traffic. The main trick for this is defining two nginx servers endpoints for
# matrix.domain.com, each listening on different ports.
#
# Configuration shamelessly stolen from [1]
#
# [1]: https://github.com/alarsyo/nixos-config/blob/main/services/matrix.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.services.matrix;

  federationPort = { public = 8448; private = 11338; };
  clientPort = { public = 443; private = 11339; };
  domain = config.networking.domain;
in
{
  options.my.services.matrix = {
    enable = lib.mkEnableOption "Matrix Synapse";
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
    };

    services.postgresqlBackup = {
      enable = true;
      databases = [ "matrix-synapse" ];
      # FIXME: best times for backup ?
      startAt = "*-*-* 23:30:00";
    };

    services.matrix-synapse = {
      enable = true;
      server_name = domain;
      public_baseurl = "https://matrix.${domain}";

      listeners = [
        # Federation
        {
          bind_address = "::1";
          port = federationPort.private;
          tls = false; # Terminated by nginx.
          x_forwarded = true;
          resources = [{ names = [ "federation" ]; compress = false; }];
        }

        # Client
        {
          bind_address = "::1";
          port = clientPort.private;
          tls = false; # Terminated by nginx.
          x_forwarded = true;
          resources = [{ names = [ "client" ]; compress = false; }];
        }
      ];
    };

    services.nginx.virtualHosts = {
      "matrix.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";

        # Or do a redirect instead of the 404, or whatever is appropriate for you.
        # But do not put a Matrix Web client here! See the Element web section below.
        locations."/".return = "404";

        locations."/_matrix" = {
          proxyPass = "http://[::1]:${toString clientPort.private}";
        };

        listen = [
          { addr = "0.0.0.0"; port = clientPort.public; ssl = true; }
          { addr = "[::]"; port = clientPort.public; ssl = true; }
        ];

      };

      # same as above, but listening on the federation port
      "matrix.${domain}_federation" = rec {
        forceSSL = true;
        serverName = "matrix.${domain}";
        useACMEHost = "${domain}";

        locations."/".return = "404";

        locations."/_matrix" = {
          proxyPass = "http://[::1]:${toString federationPort.private}";
        };

        listen = [
          { addr = "0.0.0.0"; port = federationPort.public; ssl = true; }
          { addr = "[::]"; port = federationPort.public; ssl = true; }
        ];

      };

      "${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";

        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "matrix.${domain}:${toString federationPort.public}"; };
          in
          ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" = { "base_url" = "https://matrix.${domain}"; };
              "m.identity_server" = { "base_url" = "https://vector.im"; };
            };
            # ACAO required to allow element-web on any URL to request this json file
          in
          ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
      };

      # Element Web app deployment
      "chat.${domain}" = {
        useACMEHost = "${domain}";
        forceSSL = true;

        root = pkgs.element-web.override {
          conf = {
            default_server_config = {
              "m.homeserver" = {
                "base_url" = "https://matrix.${domain}";
                "server_name" = "${domain}";
              };
              "m.identity_server" = {
                "base_url" = "https://vector.im";
              };
            };
            showLabsSettings = true;
            defaultCountryCode = "FR"; # cocorico
            roomDirectory = {
              "servers" = [
                "matrix.org"
                "mozilla.org"
              ];
            };
          };
        };
      };
    };

    # For administration tools.
    environment.systemPackages = [ pkgs.matrix-synapse ];

    networking.firewall.allowedTCPPorts = [
      clientPort.public
      federationPort.public
    ];
  };
}

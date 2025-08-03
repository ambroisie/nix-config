# Matrix homeserver setup, using different endpoints for federation and client
# traffic. The main trick for this is defining two nginx servers endpoints for
# matrix.domain.com, each listening on different ports.
#
# Configuration shamelessly stolen from [1]
#
# [1]: https://github.com/alarsyo/nixos-config/blob/main/services/matrix.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.my.services.matrix;

  domain = config.networking.domain;
  matrixDomain = "matrix.${domain}";

  serverConfig = {
    "m.server" = "${matrixDomain}:443";
  };
  clientConfig = {
    "m.homeserver" = {
      "base_url" = "https://${matrixDomain}";
      "server_name" = domain;
    };
    "m.identity_server" = {
      "base_url" = "https://vector.im";
    };
  };

  # ACAO required to allow element-web on any URL to request this json file
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  options.my.services.matrix = with lib; {
    enable = mkEnableOption "Matrix Synapse";

    port = mkOption {
      type = types.port;
      default = 8448;
      example = 8008;
      description = "Internal port for listeners";
    };

    secretFile = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/var/lib/matrix/shared-secret-config.yaml";
      description = "Shared secret to register users";
    };

    mailConfigFile = mkOption {
      type = types.str;
      example = "/var/lib/matrix/email-config.yaml";
      description = ''
        Configuration file for mail setup.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      '';
    };

    services.matrix-synapse = {
      enable = true;
      dataDir = "/var/lib/matrix-synapse";

      settings = {
        server_name = domain;
        public_baseurl = "https://${matrixDomain}";

        enable_registration = false;

        listeners = [
          {
            inherit (cfg) port;
            bind_addresses = [ "::1" ];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
              {
                names = [ "client" ];
                compress = true;
              }
              {
                names = [ "federation" ];
                compress = false;
              }
            ];
          }
        ];

        account_threepid_delegates = {
          msisdn = "https://vector.im";
        };

        experimental_features = {
          spaces_enabled = true;
        };
      };

      extraConfigFiles = [
        cfg.mailConfigFile
      ] ++ lib.optional (cfg.secretFile != null) cfg.secretFile;
    };

    my.services.nginx.virtualHosts = {
      # Element Web app deployment
      chat = {
        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig;
            show_labs_settings = true;
            default_country_code = "FR"; # cocorico
            room_directory = {
              "servers" = [
                domain
                "matrix.org"
                "mozilla.org"
              ];
            };
          };
        };
      };
      matrix = {
        # Somewhat unused, but necessary for port collision detection
        inherit (cfg) port;

        extraConfig = {
          locations = {
            # Or do a redirect instead of the 404, or whatever is appropriate
            # for you. But do not put a Matrix Web client here! See the
            # Element web section below.
            "/".return = "404";

            "/_matrix".proxyPass = "http://[::1]:${toString cfg.port}";
            "/_synapse/client".proxyPass = "http://[::1]:${toString cfg.port}";
          };
        };
      };
    };

    # Those are too complicated to use my wrapper...
    services.nginx.virtualHosts = {
      "${domain}" = {
        forceSSL = true;
        useACMEHost = domain;

        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
    };

    # For administration tools.
    environment.systemPackages = [ pkgs.matrix-synapse ];

    my.services.backup = {
      paths = [
        config.services.matrix-synapse.dataDir
      ];
    };
  };
}

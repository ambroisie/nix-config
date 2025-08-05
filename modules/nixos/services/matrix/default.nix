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

  federationPort = { public = 8448; private = 11338; };
  clientPort = { public = 443; private = 11339; };
  domain = config.networking.domain;
  matrixDomain = "matrix.${domain}";

  serverConfig = {
    "m.server" = "${matrixDomain}:${toString federationPort.public}";
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
          # Federation
          {
            bind_addresses = [ "::1" ];
            port = federationPort.private;
            tls = false; # Terminated by nginx.
            x_forwarded = true;
            resources = [{ names = [ "federation" ]; compress = false; }];
          }

          # Client
          {
            bind_addresses = [ "::1" ];
            port = clientPort.private;
            tls = false; # Terminated by nginx.
            x_forwarded = true;
            resources = [{ names = [ "client" ]; compress = false; }];
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
      # Dummy VHosts for port collision detection
      matrix-federation = {
        port = federationPort.private;
      };
      matrix-client = {
        port = clientPort.private;
      };
    };

    # Those are too complicated to use my wrapper...
    services.nginx.virtualHosts = {
      ${matrixDomain} = {
        onlySSL = true;
        useACMEHost = domain;

        locations =
          let
            proxyToClientPort = {
              proxyPass = "http://[::1]:${toString clientPort.private}";
            };
          in
          {
            # Or do a redirect instead of the 404, or whatever is appropriate
            # for you. But do not put a Matrix Web client here! See the
            # Element web section below.
            "/".return = "404";

            "/_matrix" = proxyToClientPort;
            "/_synapse/client" = proxyToClientPort;
          };

        listen = [
          { addr = "0.0.0.0"; port = clientPort.public; ssl = true; }
          { addr = "[::]"; port = clientPort.public; ssl = true; }
        ];

      };

      # same as above, but listening on the federation port
      "${matrixDomain}_federation" = {
        onlySSL = true;
        serverName = matrixDomain;
        useACMEHost = domain;

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
        useACMEHost = domain;

        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
    };

    # For administration tools.
    environment.systemPackages = [ pkgs.matrix-synapse ];

    networking.firewall.allowedTCPPorts = [
      clientPort.public
      federationPort.public
    ];

    my.services.backup = {
      paths = [
        config.services.matrix-synapse.dataDir
      ];
    };
  };
}

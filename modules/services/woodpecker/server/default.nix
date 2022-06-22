{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.woodpecker;
in
{
  config = lib.mkIf cfg.enable {
    systemd.services.woodpecker-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "postgresql.service" ];
      serviceConfig = {
        EnvironmentFile = [
          cfg.secretFile
          cfg.sharedSecretFile
        ];
        Environment = [
          "WOODPECKER_SERVER_ADDR=:${toString cfg.port}"
          "WOODPECKER_GRPC_ADDR=:${toString cfg.grpcPort}"
          "WOODPECKER_HOST=https://woodpecker.${config.networking.domain}"
          "WOODPECKER_DATABASE_DRIVER=postgres"
          "WOODPECKER_DATABASE_DATASOURCE=postgres:///woodpecker?host=/run/postgresql"
          "WOODPECKER_ADMIN=${cfg.admin}"
          # FIXME: not supported?
          "WOODPECKER_JSONNET_ENABLED=true"
          "WOODPECKER_STARLARK_ENABLED=true"
        ];
        ExecStart = "${pkgs.ambroisie.woodpecker-server}/bin/woodpecker-server";
        User = "woodpecker";
        Group = "woodpecker";
      };
    };

    users.users.woodpecker = {
      isSystemUser = true;
      createHome = true;
      group = "woodpecker";
    };
    users.groups.woodpecker = { };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "woodpecker" ];
      ensureUsers = [{
        name = "woodpecker";
        ensurePermissions = {
          "DATABASE woodpecker" = "ALL PRIVILEGES";
        };
      }];
    };

    my.services.nginx.virtualHosts = [
      {
        subdomain = "woodpecker";
        inherit (cfg) port;
      }
      {
        subdomain = "woodpecker-grpc";
        port = cfg.grpcPort;
      }
    ];
  };
}

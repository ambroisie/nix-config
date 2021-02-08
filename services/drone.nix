# A docker-based CI/CD system
#
# Inspired by [1]
# [1]: https://github.com/Mic92/dotfiles/blob/master/nixos/eve/modules/drone.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.drone;

  domain = config.networking.domain;
  droneDomain = "drone.${domain}";

  hasRunner = (name: builtins.elem name cfg.runners);

  execPkg = pkgs.nur.repos.mic92.drone-runner-exec;

  dockerPkg = with pkgs; with stdenv; buildGoModule rec {
    pname = "drone-runner-docker";
    version = "2020-04-19";

    src = fetchFromGitHub {
      owner = "drone-runners";
      repo = "drone-runner-docker";
      rev = "v1.6.3";
      sha256 = "sha256-WI3pr0t6EevIBOQwCAI+CY2O8Q7+W/CLDT/5Y0+tduQ=";
    };

    vendorSha256 = "sha256-tQPM91jMH2/nJ2pq8ExS/dneeLNb/vcL9kmEjyNtl5Y=";

    meta = with lib; {
      description = "Drone pipeline runner that executes builds using docker";
      homepage = "https://github.com/drone-runners/drone-runner-docker";
      # https://polyformproject.org/licenses/small-business/1.0.0/
      license = licenses.unfree;
    };
  };
in
{
  options.my.services.drone = with lib; {
    enable = mkEnableOption "Drone CI";
    runners = mkOption {
      type = with types; listOf (enum [ "exec" "docker" ]);
      default = [ ];
      example = [ "exec" "docker" ];
      description = "Types of runners to enable";
    };
    admin = mkOption {
      type = types.str;
      default = "ambroisie";
      example = "admin";
      description = "Name of the admin user";
    };
    port = mkOption {
      type = types.port;
      default = 3030;
      example = 8080;
      description = "Internal port of the Drone UI";
    };
    secretFile = mkOption {
      type = types.str;
      example = "/run/secrets/drone-gitea.env";
      description = "Secrets to inject into Drone server";
    };
    sharedSecretFile = mkOption {
      type = types.str;
      example = "/run/secrets/drone-rpc.env";
      description = "Shared RPC secret to inject into server and runners";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.drone-server = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        EnvironmentFile = [
          cfg.secretFile
          cfg.sharedSecretFile
        ];
        Environment = [
          "DRONE_DATABASE_DATASOURCE=postgres:///drone?host=/run/postgresql"
          "DRONE_SERVER_HOST=${droneDomain}"
          "DRONE_SERVER_PROTO=https"
          "DRONE_DATABASE_DRIVER=postgres"
          "DRONE_SERVER_PORT=:${toString cfg.port}"
          "DRONE_USER_CREATE=username:${cfg.admin},admin:true"
          "DRONE_JSONNET_ENABLED=true"
          "DRONE_STARLARK_ENABLED=true"
        ];
        ExecStart = "${pkgs.drone}/bin/drone-server";
        User = "drone";
        Group = "drone";
      };
    };

    users.users.drone = {
      isSystemUser = true;
      createHome = true;
      group = "drone";
    };
    users.groups.drone = { };

    services.postgresql = {
      ensureDatabases = [ "drone" ];
      ensureUsers = [{
        name = "drone";
        ensurePermissions = {
          "DATABASE drone" = "ALL PRIVILEGES";
        };
      }];
    };

    services.nginx.virtualHosts."${droneDomain}" = {
      forceSSL = true;
      useACMEHost = domain;

      locations."/".proxyPass = "http://localhost:${toString cfg.port}";
    };

    # Docker runner
    systemd.services.drone-runner-docker = lib.mkIf (hasRunner "docker") {
      wantedBy = [ "multi-user.target" ];
      # might break deployment
      restartIfChanged = false;
      confinement.enable = true;
      serviceConfig = {
        Environment = [
          "DRONE_SERVER_HOST=${droneDomain}"
          "DRONE_SERVER_PROTO=https"
          "DRONE_RUNNER_CAPACITY=10"
          "CLIENT_DRONE_RPC_HOST=127.0.0.1:${toString cfg.port}"
        ];
        BindPaths = [
          "/var/run/docker.sock"
        ];
        EnvironmentFile = [
          cfg.sharedSecretFile
        ];
        ExecStart = "${dockerPkg}/bin/drone-runner-docker";
        User = "drone-runner-docker";
        Group = "drone-runner-docker";
      };
    };

    # Make sure it is activated in that case
    virtualisation.docker.enable = lib.mkIf (hasRunner "docker") true;

    users.users.drone-runner-docker = lib.mkIf (hasRunner "docker") {
      isSystemUser = true;
      group = "drone-runner-docker";
      extraGroups = [ "docker" ]; # Give access to the daemon
    };
    users.groups.drone-runner-docker = lib.mkIf (hasRunner "docker") { };

    # Exec runner
    systemd.services.drone-runner-exec = lib.mkIf (hasRunner "exec") {
      wantedBy = [ "multi-user.target" ];
      # might break deployment
      restartIfChanged = false;
      confinement.enable = true;
      confinement.packages = with pkgs; [
        git
        gnutar
        bash
        nixUnstable
        gzip
      ];
      path = with pkgs; [
        git
        gnutar
        bash
        nixUnstable
        gzip
      ];
      serviceConfig = {
        Environment = [
          "DRONE_SERVER_HOST=${droneDomain}"
          "DRONE_SERVER_PROTO=https"
          "DRONE_RUNNER_CAPACITY=10"
          "CLIENT_DRONE_RPC_HOST=127.0.0.1:${toString cfg.port}"
          "NIX_REMOTE=daemon"
          "PAGER=cat"
        ];
        BindPaths = [
          "/nix/var/nix/daemon-socket/socket"
          "/run/nscd/socket"
          "/var/lib/drone"
        ];
        BindReadOnlyPaths = [
          "/etc/passwd:/etc/passwd"
          "/etc/group:/etc/group"
          "/nix/var/nix/profiles/system/etc/nix:/etc/nix"
          "${config.environment.etc."ssl/certs/ca-certificates.crt".source}:/etc/ssl/certs/ca-certificates.crt"
          "${config.environment.etc."ssh/ssh_known_hosts".source}:/etc/ssh/ssh_known_hosts"
          "/etc/machine-id"
          # channels are dynamic paths in the nix store, therefore we need to bind mount the whole thing
          "/nix/"
        ];
        EnvironmentFile = [
          cfg.sharedSecretFile
        ];
        ExecStart = "${execPkg}/bin/drone-runner-exec";
        User = "drone-runner-exec";
        Group = "drone-runner-exec";
      };
    };

    users.users.drone-runner-exec = lib.mkIf (hasRunner "exec") {
      isSystemUser = true;
      group = "drone-runner-exec";
    };
    users.groups.drone-runner-exec = lib.mkIf (hasRunner "exec") { };
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.woodpecker;
  hasRunner = (name: builtins.elem name cfg.runners);
  agentPkg = pkgs.ambroisie.woodpecker-agent;
in
{
  config = lib.mkIf (cfg.enable && hasRunner "local") {
    systemd.services.woodpecker-agent-local = {
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
          "WOODPECKER_SERVER=localhost:${toString cfg.grpcPort}"
          "WOODPECKER_GRPC_SECURE=true"
          "WOODPECKER_MAX_PROCS=10"
          "WOODPECKER_BACKEND=local"
          "NIX_REMOTE=daemon"
          "PAGER=cat"
        ];
        BindPaths = [
          "/nix/var/nix/daemon-socket/socket"
          "/run/nscd/socket"
        ];
        BindReadOnlyPaths = [
          "/etc/resolv.conf:/etc/resolv.conf"
          "/etc/resolvconf.conf:/etc/resolvconf.conf"
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
        ExecStart = "${agentPkg}/bin/woodpecker-agent";
        User = "woodpecker-agent-local";
        Group = "woodpecker-agent-local";
      };
    };

    users.users.woodpecker-agent-local = {
      isSystemUser = true;
      group = "woodpecker-agent-local";
    };
    users.groups.woodpecker-agent-local = { };
  };
}

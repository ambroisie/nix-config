{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.woodpecker;
  hasRunner = (name: builtins.elem name cfg.runners);
  agentPkg = pkgs.ambroisie.woodpecker-agent;
in
{
  config = lib.mkIf (cfg.enable && hasRunner "docker") {
    systemd.services.woodpecker-agent-docker = {
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.socket" ]; # Needs the socket to be available
      # might break deployment
      restartIfChanged = false;
      confinement.enable = true;
      serviceConfig = {
        Environment = [
          "WOODPECKER_SERVER=localhost:${toString cfg.grpcPort}"
          "WOODPECKER_GRPC_SECURE=true"
          "WOODPECKER_MAX_PROCS=10"
          "WOODPECKER_BACKEND=docker"
          # FIXME: docker settings
        ];
        BindPaths = [
          "/var/run/docker.sock"
        ];
        EnvironmentFile = [
          cfg.sharedSecretFile
        ];
        ExecStart = "${agentPkg}/bin/woodpecker-agent";
        User = "woodpecker-agent-docker";
        Group = "woodpecker-agent-docker";
      };
    };

    # Make sure it is activated in that case
    virtualisation.docker.enable = true;

    users.users.woodpecker-agent-docker = {
      isSystemUser = true;
      group = "woodpecker-agent-docker";
      extraGroups = [ "docker" ]; # Give access to the daemon
    };
    users.groups.woodpecker-agent-docker = { };
  };
}

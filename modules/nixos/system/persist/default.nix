# Ephemeral root configuration
{ config, inputs, lib, ... }:
let
  cfg = config.my.system.persist;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.my.system.persist = with lib; {
    enable = mkEnableOption "stateless system configuration";

    mountPoint = lib.mkOption {
      type = types.str;
      default = "/persistent";
      example = "/etc/nix/persist";
      description = ''
        Which mount point should be used to persist this system's files and
        directories.
      '';
    };

    files = lib.mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [
        "/etc/nix/id_rsa"
      ];
      description = ''
        Additional files in the root to link to persistent storage.
      '';
    };

    directories = lib.mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [
        "/var/lib/libvirt"
      ];
      description = ''
        Additional directories in the root to link to persistent storage.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."${cfg.mountPoint}" = {
      files = [
        "/etc/machine-id"
        "/etc/adjtime"
        "/var/lib/systemd/timesync/clock"
      ]
      ++ lib.unique cfg.files
      ;

      directories = [
        "/etc/nixos" # In case it's storage directory of our configuration
        "/var/log"
        "/var/lib/nixos" # UID/GID maps
        "/var/lib/systemd/coredump"

        "/var/lib/systemd" # FIXME: needed?
        "/var/spool" # FIXME: needed?
        "/var/tmp" # FIXME: needed?
      ]
      ++ lib.unique cfg.directories
      ;
    };
  };
}

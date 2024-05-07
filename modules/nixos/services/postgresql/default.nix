{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.postgresql;
in
{
  options.my.services.postgresql = with lib; {
    enable = my.mkDisableOption "postgres configuration";

    # Transient option to be enabled for migrations
    upgradeScript = mkEnableOption "postgres upgrade script";
  };

  config = lib.mkMerge [
    # Let other services enable postgres when they need it
    (lib.mkIf cfg.enable {
      services.postgresql = {
        package = pkgs.postgresql_13;
      };
    })

    # Taken from the manual
    (lib.mkIf cfg.upgradeScript {
      containers.temp-pg.config.services.postgresql = {
        enable = true;
        package = pkgs.postgresql_13;
      };

      environment.systemPackages =
        let
          pgCfg = config.services.postgresql;
          newPackage' = pkgs.postgresql_13;

          oldPackage = if pgCfg.enableJIT then pgCfg.package.withJIT else pgCfg.package;
          oldData = pgCfg.dataDir;
          oldBin = "${if pgCfg.extraPlugins == [] then oldPackage else oldPackage.withPackages pgCfg.extraPlugins}/bin";

          newPackage = if pgCfg.enableJIT then newPackage'.withJIT else newPackage';
          newData = "/var/lib/postgresql/${newPackage.psqlSchema}";
          newBin = "${if pgCfg.extraPlugins == [] then newPackage else newPackage.withPackages pgCfg.extraPlugins}/bin";
        in
        [
          (pkgs.writeScriptBin "upgrade-pg-cluster" ''
            #!/usr/bin/env bash

            set -eux
            export OLDDATA="${oldData}"
            export NEWDATA="${newData}"
            export OLDBIN="${oldBin}"
            export NEWBIN="${newBin}"

            if [ "$OLDDATA" -ef "$NEWDATA" ]; then
              echo "Cannot migrate to same data directory" >&2
              exit 1
            fi

            install -d -m 0700 -o postgres -g postgres "$NEWDATA"
            cd "$NEWDATA"
            sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA"

            systemctl stop postgresql    # old one

            sudo -u postgres "$NEWBIN/pg_upgrade" \
              --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
              --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
              "$@"
          '')
        ];
    })
  ];
}

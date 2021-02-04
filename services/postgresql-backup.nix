# Backup your data, kids!
{ config, lib, ... }:
let
  cfg = config.my.services.postgresql-backup;
in
{
  options.my.services.postgresql-backup = {
    enable = lib.mkEnableOption "Backup SQL databases";
  };

  config = lib.mkIf cfg.enable {
    services.postgresqlBackup = {
      enable = true;
    };
  };
}

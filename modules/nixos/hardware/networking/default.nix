{ config, lib, ... }:
let
  cfg = config.my.hardware.networking;
in
{
  options.my.hardware.networking = with lib; {
    externalInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth0";
      description = ''
        Name of the network interface that egresses to the internet. Used for
        e.g. NATing internal networks.
      '';
    };

    wireless = {
      enable = mkEnableOption "wireless configuration";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.wireless.enable {
      networking.networkmanager.enable = true;

      # IWD needs persistence if enabled

      # Persist NetworkManager files
      my.system.persist.files = [
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/seen-bssids"
        "/var/lib/NetworkManager/timestamps"
      ];
      my.system.persist.directories = [
        "/etc/NetworkManager/system-connections"
      ];
    })
  ];
}

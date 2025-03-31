{ config, lib, ... }:
let
  cfg = config.my.services.servarr.jackett;
in
{
  options.my.services.servarr.jackett = with lib; {
    enable = lib.mkEnableOption "Jackett" // {
      default = config.my.services.servarr.enableAll;
    };
  };

  config = lib.mkIf cfg.enable {
    services.jackett = {
      enable = true;
    };

    # Jackett wants to eat *all* my RAM if left to its own devices
    systemd.services.jackett = {
      serviceConfig = {
        MemoryHigh = "15%";
        MemoryMax = "25%";
      };
    };

    my.services.nginx.virtualHosts = {
      jackett = {
        port = 9117;
      };
    };

    # Jackett does not log authentication failures...
  };
}

# Groceries and household management
{ config, lib, ... }:
let
  cfg = config.my.services.grocy;
in
{
  options.my.services.grocy = with lib; {
    enable = mkEnableOption "Grocy household ERP";
  };

  config = lib.mkIf cfg.enable {
    services.grocy = {
      enable = true;

      # The service sets up the reverse proxy automatically
      hostName = "grocy.${config.networking.domain}";

      nginx = {
        enableSSL = true;
      };

      settings = {
        currency = "EUR";
        culture = "en";
        calendar = {
          # Start on Monday
          firstDayOfWeek = 1;
          showWeekNumber = true;
        };
      };
    };
  };
}

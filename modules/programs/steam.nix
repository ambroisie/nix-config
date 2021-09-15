{ config, lib, ... }:
let
  cfg = config.my.programs.steam;
in
{
  options.my.programs.steam = with lib; {
    enable = mkEnableOption "steam configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
  };
}

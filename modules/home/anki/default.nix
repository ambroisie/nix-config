{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.anki;
in
{
  options.my.home.anki = with lib; {
    enable = mkEnableOption "anki configuration";

    package = mkPackageOption pkgs "anki" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}

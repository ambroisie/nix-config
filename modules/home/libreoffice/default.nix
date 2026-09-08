{ config, lib, ... }:
let
  cfg = config.my.home.libreoffice;
in
{
  options.my.home.libreoffice = with lib; {
    enable = mkEnableOption "LibreOffice configuration";

    package = mkPackageOption pkgs "libreoffice" { };
  };

  config = lib.mkIf cfg.enable {
    programs.libreoffice = {
      enable = true;

      inherit (cfg) package;
    };

    config.my.home.xdg.mime-apps = lib.mkIf cfg.enable {
      applications.office = {
        database = [ "libreoffice-base.desktop" ];
        formula = [ "libreoffice-math.desktop" ];
        graphics = [ "libreoffice-draw.desktop" ];
        presentation = [ "libreoffice-impress.desktop" ];
        spreadsheet = [ "libreoffice-calc.desktop" ];
        text = [ "libreoffice-writer.desktop" ];
      };
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.my.home.zathura;
in
{
  options.my.home.zathura = with lib; {
    enable = mkEnableOption "zathura configuration";
  };

  config.programs.zathura = lib.mkIf cfg.enable {
    enable = true;

    options = {
      # Show '~' instead of full path to '$HOME' in window title
      "window-title-home-tilde" = true;
      # Show '~' instead of full path to '$HOME' in status bar
      "statusbar-home-tilde" = true;
    };
  };

  config.my.home.xdg.mime-apps = lib.mkIf cfg.enable {
    applications.media.document = {
      comic = [ "org.pwmt.zathura.desktop" ];
      ebook = [ "org.pwmt.zathura.desktop" ];
      pdf = [ "org.pwmt.zathura.desktop" ];
    };
  };
}

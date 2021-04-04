{ config, lib, pkgs, ... }:
let
  isEnabled = config.my.home.wm.windowManager == "i3";
in
{
  config = lib.mkIf isEnabled {
    programs.rofi = {
      enable = true;

      package = pkgs.rofi.override {
        plugins = with pkgs; [
          rofi-emoji
        ];
      };

      theme = "gruvbox-dark-hard";
    };
  };
}

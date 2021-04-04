{ config, lib, pkgs, ... }:
let
  isEnabled = config.my.home.wm.windowManager == "i3";
in
{
  config = lib.mkIf isEnabled {
    home.packages = with pkgs; [
      alsaUtils # Used by `sound` block
      lm_sensors # Used by `temperature` block
    ];

    programs.i3status-rust = {
      enable = true;

      bars = {
        top = {
          blocks = [
            {
              block = "music";
              buttons = [ "prev" "play" "next" ];
            }
            {
              block = "cpu";
            }
            {
              block = "disk_space";
            }
            {
              block = "net";
              format = "{ssid} {ip} {signal_strength}";
            }
            {
              block = "battery";
              format = "{percentage}% ({time})";
              full_format = "{percentage}%";
            }
            {
              block = "temperature";
            }
            {
              block = "sound";
            }
            {
              block = "time";
              format = "%F %T";
            }
          ];
        };
      };
    };
  };
}

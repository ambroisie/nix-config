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
          blocks = builtins.filter (attr: attr != { }) [
            {
              block = "music";
              buttons = [ "prev" "play" "next" ];
              hide_when_empty = true;
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
            (lib.optionalAttrs (config.my.home.gammastep.enable) {
              block = "hueshift";
              hue_shifter = "gammastep";
              step = 100;
              click_temp = config.my.home.gammastep.temperature.day;
            })
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

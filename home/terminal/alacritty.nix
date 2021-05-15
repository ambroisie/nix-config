{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.terminal;
in
{
  config = lib.mkIf (cfg.program == "alacritty") {
    programs.alacritty = {
      enable = true;

      settings = {
        env = {
          # Font density scaling issues...
          WINIT_HIDPI_FACTOR = "1.0";
          WINIT_X11_SCALE_FACTOR = "1";
        };

        font = {
          size = 9.0;
        };

        colors = with cfg.colors; {
          primary = {
            background = background;
            foreground = foreground;
            bright_foreground = foregroundBold;
          };

          normal = {
            black = black;
            red = red;
            green = green;
            yellow = yellow;
            blue = blue;
            magenta = magenta;
            cyan = cyan;
            white = white;
          };

          bright = {
            black = blackBold;
            red = redBold;
            green = greenBold;
            yellow = yellowBold;
            blue = blueBold;
            magenta = magentaBold;
            cyan = cyanBold;
            white = whiteBold;
          };
        };
      };
    };
  };
}

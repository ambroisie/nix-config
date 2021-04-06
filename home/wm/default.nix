{ config, lib, pkgs, ... }:
let
  mkRelatedOption = description: relatedWMs:
    let
      isActivatedWm = wm: config.my.home.wm.windowManager == wm;
    in
    (lib.mkEnableOption description) // {
      default = builtins.any isActivatedWm relatedWMs;
    };
in
{
  imports = [
    ./dunst.nix
    ./i3.nix
    ./i3bar.nix
    ./rofi.nix
    ./screen-lock.nix
  ];

  options.my.home.wm = with lib; {
    windowManager = mkOption {
      type = with types; nullOr (enum [ "i3" ]);
      default = null;
      example = "i3";
      description = "Which window manager to use for home session";
    };

    dunst = {
      enable = mkRelatedOption "dunst configuration" [ "i3" ];
    };

    i3bar = {
      enable = mkRelatedOption "i3bar configuration" [ "i3" ];
    };

    rofi = {
      enable = mkRelatedOption "rofi menu" [ "i3" ];
    };

    screen-lock = {
      enable = mkRelatedOption "automatic X screen locker" [ "i3" ];

      command = mkOption {
        type = types.str;
        default = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
        example = "\${pkgs.i3lock}/bin/i3lock -n -i lock.png";
        description = "Locker command to run";
      };

      timeout = mkOption {
        type = types.ints.between 1 60;
        default = 5;
        example = 1;
        description = "Inactive time interval to lock the screen automatically";
      };
    };
  };
}

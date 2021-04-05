{ config, lib, ... }:
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
    ./i3.nix
    ./i3bar.nix
    ./rofi.nix
  ];

  options.my.home.wm = with lib; {
    windowManager = mkOption {
      type = with types; nullOr (enum [ "i3" ]);
      default = null;
      example = "i3";
      description = "Which window manager to use for home session";
    };

    i3bar = {
      enable = mkRelatedOption "i3bar configuration" [ "i3" ];
    };

    rofi = {
      enable = mkRelatedOption "rofi menu" [ "i3" ];
    };
  };
}

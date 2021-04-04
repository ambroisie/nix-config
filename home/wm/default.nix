{ lib, ... }:
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
  };
}

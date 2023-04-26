{ config, lib, ... }:
let
  cfg = config.my.home.atuin;
in
{
  options.my.home.atuin = with lib; {
    enable = my.mkDisableOption "atuin configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;

      flags = [
        # I *despise* this hijacking of the up key, even though I use Ctrl-p
        "--disable-up-arrow"
      ];

      settings = {
        # The package is managed by Nix
        update_check = false;
        # I don't care for the fancy display
        style = "compact";
      };
    };
  };
}

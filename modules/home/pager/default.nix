{ config, lib, ... }:
let
  cfg = config.my.home.pager;
in
{
  options.my.home.pager = with lib; {
    enable = my.mkDisableOption "pager configuration";
  };


  config = lib.mkIf cfg.enable {
    programs.less = {
      enable = true;

      config = ''
        #command
        # Quit without clearing the screen on `Q`
        Q toggle-option -!^Predraw-on-quit\nq
      '';
    };

    home.sessionVariables = {
      # My default pager
      PAGER = "less";
      # Set `LESS` in the environment so it overrides git's pager (and others)
      LESS =
        let
          options = {
            # Always use the alternate screen (so that it is cleared on exit)
            "+no-init" = true;
            # Write text top-down, rather than from the bottom
            clear-screen = true;
            # Interpret (some) escape sequences
            RAW-CONTROL-CHARS = true;
          };
        in
        lib.concatStringsSep " " (lib.cli.toCommandLineGNU { } options);
    };
  };
}

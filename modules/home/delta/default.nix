{ config, pkgs, lib, ... }:
let
  cfg = config.my.home.delta;

  configFormat = pkgs.formats.gitIni { };
  configPath = "${config.xdg.configHome}/delta/config";
in
{
  options.my.home.delta = with lib; {
    enable = my.mkDisableOption "delta configuration";

    package = mkPackageOption pkgs "delta" { };

    git = {
      enable = my.mkDisableOption "git integration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."delta/config".source = configFormat.generate "delta-config" {
      delta = {
        features = "diff-highlight decorations";

        # Less jarring style for `diff-highlight` emulation
        diff-highlight = {
          minus-style = "red";
          minus-non-emph-style = "red";
          minus-emph-style = "bold red 52";

          plus-style = "green";
          plus-non-emph-style = "green";
          plus-emph-style = "bold green 22";

          whitespace-error-style = "reverse red";
        };

        # Personal preference for easier reading
        decorations = {
          commit-style = "raw"; # Do not recolor meta information
          keep-plus-minus-markers = true;
          paging = "always";
        };
      };
    };

    programs.git = lib.mkIf cfg.git.enable {
      delta = {
        enable = true;
        inherit (cfg) package;
      };

      includes = [
        {
          path = configPath;
        }
      ];
    };
  };
}

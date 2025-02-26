{ config, pkgs, lib, ... }:
let
  cfg = config.my.home.delta;
in
{
  options.my.home.delta = with lib; {
    enable = my.mkDisableOption "delta configuration";

    package = mkPackageOption pkgs "delta" { };

    git = {
      enable = my.mkDisableOption "git integration";
    };

    jujutsu = {
      enable = my.mkDisableOption "jujutsu integration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.delta = {
      enable = true;

      inherit (cfg) package;

      enableGitIntegration = cfg.git.enable;

      options = {
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

    # `jj log -p` does not use `delta`
    # https://github.com/jj-vcs/jj/issues/4142
    programs.jujutsu = lib.mkIf cfg.jujutsu.enable {
      settings = {
        merge-tools = {
          delta = {
            # Errors are signaled with exit codes greater or equal to 2
            diff-expected-exit-codes = [ 0 1 ];
          };
        };

        ui = {
          # Delta expects a `git diff` input
          diff-formatter = ":git";

          # `finalPackage` automatically applied `--config` if necessary
          pager = [ (lib.getExe config.programs.delta.finalPackage) ];
        };
      };
    };
  };
}

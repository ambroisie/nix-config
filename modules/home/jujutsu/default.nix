{ config, pkgs, lib, ... }:
let
  cfg = config.my.home.jujutsu;

  inherit (lib.my) mkMailAddress;
in
{
  options.my.home.jujutsu = with lib; {
    enable = my.mkDisableOption "jujutsu configuration";

    package = mkPackageOption pkgs "jujutsu" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # For `jj git` commands
        assertion = cfg.enable -> config.my.home.git.enable;
        message = ''
          `config.my.home.jujutsu` relies on `config.my.home.git` being enabled.
        '';
      }
    ];

    programs.jujutsu = {
      enable = true;

      inherit (cfg) package;

      settings = {
        # Who am I?
        user = {
          name = "Bruno BELANYI";
          email = mkMailAddress "bruno" "belanyi.fr";
        };

        aliases = {
          jj = [ ];
          lol = [ "log" "-r" "..@" "-T" "builtin_log_oneline" ];
          lola = [ "lol" "-r" "all()" ];
        };

        ui = {
          # Stop nagging me about it, though I am not a fan of its UI.
          diff-editor = ":builtin";
          # I don't like word-diff
          diff-formatter = ":git";
          # Stop nagging me about it, though I am not a fan of its UI.
          merge-editor = ":builtin";
          # Does not honor `$PAGER` (anymore)
          pager = lib.mkDefault config.home.sessionVariables.PAGER;
        };

        templates = {
          # Equivalent to `commit.verbose = true` in Git
          draft_commit_description = "commit_description_verbose(self)";
        };

        template-aliases = {
          "commit_description_verbose(commit)" = ''
            concat(
              commit_description(commit),
              "JJ: ignore-rest\n",
              diff.git(),
            )
          '';
          "commit_description(commit)" = ''
            concat(
              commit.description(), "\n",
              "JJ: This commit contains the following changes:\n",
              indent("JJ:    ", diff.stat(72)),
            )
          '';
        };

        "--scope" = [
          # Multiple identities
          {
            "--when" = {
              repositories = [ "~/git/EPITA/" ];
            };
            user = {
              name = "Bruno BELANYI";
              email = mkMailAddress "bruno.belanyi" "epita.fr";
            };
          }
          {
            "--when" = {
              repositories = [ "~/git/work/" ];
            };
            user = {
              name = "Bruno BELANYI";
              email = mkMailAddress "ambroisie" "google.com";
            };
          }
        ];
      };
    };

    # To drop in a `local.toml` configuration, not-versioned
    xdg.configFile = {
      "jj/conf.d/.keep".text = "";
    };
  };
}

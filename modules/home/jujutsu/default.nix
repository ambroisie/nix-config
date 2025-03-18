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
          jj = [ "util" "exec" "--" "jj" ];
          # FIXME:
          # * topo sort by default (I think? test it)
          # * still not a big fan of the template
          lol = [ "log" "-r" "..@" "-T" "builtin_log_oneline" ];
          lola = [ "lol" "-r" "all()" ];
          # TODO:
          # * `pick` (https://github.com/jj-vcs/jj/issues/5446): [ "util" "exec" "--" "bash" "-c" "jj log -p -r \"diff_contains($1)\"" ]
          # * `root`: `jj workspace root` (barely necessary then)
        };

        # FIXME: git equivalents
        # blame = {
        #   coloring = "repeatedLines";
        #   markIgnoredLines = true;
        #   markUnblamables = true;
        # };
        # FIXME: log colors should probably match git
        # FIXME: patience diff?
        # FIXME: fetch prune/pruneTags?
        # FIXME: pull.rebase=true? Probably true TBH
        # FIXME: push.default=simple? Probably true TBH
        # FIXME: conflict style? ui.conflict-marker-style=git is diff3/zdiff3

        # FIXME: from ma_9's config, plus my own stuff
        # snapshot = {
        #   auto-track = "none()";
        # };
        #
        # ui = {
        #   diff-editor = ":builtin"; # To silence hints
        #   movement = {
        #     edit = false;
        #   };
        # };

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
          # FIXME: use `diff.summary()` instead? Supported by syntax highlighting
          # See https://github.com/jj-vcs/jj/issues/1946#issuecomment-2572986485
          # FIXME: tree-sitter grammar isn't in `nvim-treesitter` (https://github.com/kareigu/tree-sitter-jjdescription)
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

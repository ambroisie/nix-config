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
          # FIXME: equivalent to `git switch -`
          # See https://github.com/jj-vcs/jj/issues/2871
          # Might be broken recently https://discord.com/channels/968932220549103686/1380272574709366989/1380432041983606855
          # TODO:
          # * `pick` (https://github.com/jj-vcs/jj/issues/5446): [ "util" "exec" "--" "bash" "-c" "jj log -p -r \"diff_contains($1)\"" "" ]
          # * `root`: `jj workspace root` (barely necessary then)
        };

        # FIXME: `extraConfig` equivalents...

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
  };
}

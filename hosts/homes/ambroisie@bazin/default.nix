# Google Laptop configuration
{ lib, options, pkgs, ... }:
{
  services.gpg-agent.enable = lib.mkForce false;

  my.home = {
    git = {
      package = pkgs.emptyDirectory;
    };

    tmux = {
      # I use scripts that use the passthrough sequence often on this host
      enablePassthrough = true;

      terminalFeatures = {
        # HTerm configured to use a more accurate terminfo entry than `xterm-256color`
        hterm-256color = { };
      };
    };

    ssh = {
      mosh = {
        package = pkgs.emptyDirectory;
      };
    };

    zsh = {
      notify = {
        enable = true;

        exclude = options.my.home.zsh.notify.exclude.default ++ [
          "adb shell$" # Only interactive shell sessions
        ];

        ssh = {
          enable = true;
          # `notify-send` is proxied to the ChromeOS layer
          useOsc777 = false;
        };
      };
    };
  };
}

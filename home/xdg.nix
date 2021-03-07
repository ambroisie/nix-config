{ config, ... }:
{
  xdg = {
    enable = true;
    # File types
    mime.enable = true;
    # File associatons
    mimeApps = {
      enable = true;
    };
    # User directories
    userDirs = {
      enable = true;
      # I want them lowercased
      desktop = "\$HOME/desktop";
      documents = "\$HOME/documents";
      download = "\$HOME/downloads";
      music = "\$HOME/music";
      pictures = "\$HOME/pictures";
      publicShare = "\$HOME/public";
      templates = "\$HOME/templates";
      videos = "\$HOME/videos";
    };
  };

  # I want a tidier home
  home.sessionVariables = with config.xdg; {
    HISTFILE = "${dataHome}/bash/history";
    LESSHISTFILE = "${dataHome}/less/history";
    LESSKEY = "${configHome}/less/lesskey";
  };
}

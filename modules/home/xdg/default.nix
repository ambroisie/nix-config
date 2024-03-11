{ config, lib, ... }:
let
  cfg = config.my.home.xdg;
in
{
  options.my.home.xdg = with lib; {
    enable = my.mkDisableOption "XDG configuration";
  };

  config.xdg = lib.mkIf cfg.enable {
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
    # A tidy home is a tidy mind
    dataFile = {
      "bash/.keep".text = "";
      "gdb/.keep".text = "";
      "tig/.keep".text = "";
    };
  };

  # I want a tidier home
  config.home.sessionVariables = with config.xdg; lib.mkIf cfg.enable {
    ANDROID_HOME = "${dataHome}/android";
    ANDROID_USER_HOME = "${configHome}/android";
    CARGO_HOME = "${dataHome}/cargo";
    DOCKER_CONFIG = "${configHome}/docker";
    GDBHISTFILE = "${dataHome}/gdb/gdb_history";
    GRADLE_USER_HOME = "${dataHome}/gradle";
    HISTFILE = "${dataHome}/bash/history";
    INPUTRC = "${configHome}/readline/inputrc";
    PSQL_HISTORY = "${dataHome}/psql_history";
    PYTHONPYCACHEPREFIX = "${cacheHome}/python/";
    PYTHONUSERBASE = "${dataHome}/python/";
    PYTHON_HISTORY = "${stateHome}/python/history";
    REDISCLI_HISTFILE = "${dataHome}/redis/rediscli_history";
    REPO_CONFIG_DIR = "${configHome}/repo";
    XCOMPOSECACHE = "${dataHome}/X11/xcompose";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
  };
}

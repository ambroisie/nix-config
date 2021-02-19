{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    # Who am I?
    userEmail = "bruno@belanyi.fr";
    userName = "Bruno BELANYI";

    # I want the full experience
    package = pkgs.gitAndTools.gitFull;

    aliases = {
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "lol --all";
      assume = "update-index --assume-unchanged";
      unassume = "update-index --no-assume-unchanged";
      assumed = "!git ls-files -v | grep ^h | cut -c 3-";
      push-new = "!git push -u origin "
        + ''"$(git branch | grep '^* ' | cut -f2- -d' ')"'';
    };

    lfs.enable = true;

    # There's more
    extraConfig = {
      # Makes it a bit more readable
      blame = {
        coloring = "repeatedLines";
        markUnblamables = true;
        markIgnoredLines = true;
      };

      # I want `pull --rebase` as a default
      branch = {
        autosetubrebase = "always";
      };

      # Shiny colors
      color = {
        ui = "auto";
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
      };

      # Pretty much the usual diff colors
      "color.diff" = {
        commit = "yellow";
        meta = "yellow";
        frag = "cyan";
        old = "red";
        new = "green";
        whitespace = "red reverse";
      };

      commit = {
        # Show my changes when writing the message
        verbose = true;
      };

      diff = {
        # Usually leads to better results
        algorithm = "patience";
      };

      fetch = {
        # I don't want hanging references
        prune = true;
        pruneTags = true;
      };

      init = {
        defaultBranch = "main";
      };

      pull = {
        # Avoid useless merge commits
        rebase = true;
      };

      push = {
        # Just yell at me instead of trying to be smart
        default = "simple";
      };

      rebase = {
        # Why isn't it the default?...
        autoSquash = true;
        autoStash = true;
      };
    };
  };
}

{ ... }:
{
  programs.jq = {
    enable = true;
    colors = {
      null = "1;30";
      false = "0;37";
      true = "0;37";
      numbers = "0;37";
      strings = "0;32";
      arrays = "1;39";
      objects = "1;39";
    };
  };
}

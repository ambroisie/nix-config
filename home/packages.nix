{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gitAndTools.tig
    rr
  ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Git related
    gitAndTools.git-absorb
    gitAndTools.git-revise
    gitAndTools.tig
    # Dev work
    rr
    # Terminal prettiness
    termite.terminfo
  ];
}

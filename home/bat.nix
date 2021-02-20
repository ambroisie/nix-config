{ config, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      pager = with config.home.sessionVariables; "${PAGER} ${LESS}";
    };
  };
}

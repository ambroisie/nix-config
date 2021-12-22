final: prev:
{
  # Do not create any file of significance
  xterm = final.runCommandNoCC "xterm" { } ''
    mkdir $out
  '';
}

{ pkgs }:
{
  lohr = pkgs.callPackage ./lohr { };

  podgrab = pkgs.callPackage ./podgrab { };
}

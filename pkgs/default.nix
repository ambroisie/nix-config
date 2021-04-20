{ pkgs }:
{
  lohr = pkgs.callPackage ./lohr { };

  nolimips = pkgs.callPackage ./nolimips { };

  podgrab = pkgs.callPackage ./podgrab { };
}

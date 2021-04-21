{ pkgs }:
{
  havm = pkgs.callPackage ./havm { };

  lohr = pkgs.callPackage ./lohr { };

  nolimips = pkgs.callPackage ./nolimips { };

  podgrab = pkgs.callPackage ./podgrab { };

  unified-hosts-lists = pkgs.callPackage ./unified-hosts-lists { };
}

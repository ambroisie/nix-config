{ self, lib, ... }:
let
  inherit (builtins) readDir pathExists;
  inherit (lib) hasPrefix hasSuffix nameValuePair removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
in
{
  # Find all nix modules in a directory, discard any prefixed with "_",
  # map a function to each resulting path, and generate an attribute set
  # to associate module name to resulting value.
  #
  # mapModules ::
  #   path
  #   (path -> any)
  #   attrs
  mapModules = dir: fn:
    mapFilterAttrs
      (n: v:
        v != null &&
        !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in
        if v == "directory" && pathExists "${path}/default.nix"
        then nameValuePair n (fn path)
        else if v == "regular" &&
          n != "default.nix" &&
          hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);
}

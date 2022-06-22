{ lib, buildGoModule, fetchFromGitHub }:
let
  inherit (import ./common.nix { inherit lib fetchFromGitHub; })
    meta
    version
    src
    ldflags
    postBuild
    ;
in
buildGoModule {
  pname = "woodpecker-agent";
  inherit version src ldflags postBuild;
  vendorSha256 = null;

  subPackages = "cmd/agent";

  CGO_ENABLED = 0;

  meta = meta // {
    description = "Woodpecker Continuous Integration agent";
  };
}

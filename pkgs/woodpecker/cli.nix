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
  pname = "woodpecker-cli";
  inherit version src ldflags postBuild;
  vendorSha256 = null;

  subPackages = "cmd/cli";

  CGO_ENABLED = 0;

  meta = meta // {
    description = "Command line client for the Woodpecker Continuous Integration server";
  };
}

{ lib, buildGoModule, fetchFromGitHub, woodpecker-frontend }:
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
  pname = "woodpecker-server";
  inherit version src ldflags postBuild;
  vendorSha256 = null;

  postPatch = ''
    cp -r ${woodpecker-frontend} web/dist
  '';

  subPackages = "cmd/server";

  CGO_ENABLED = 1;

  passthru = {
    inherit woodpecker-frontend;

    updateScript = ./update.sh;
  };

  meta = meta // {
    description = "Woodpecker Continuous Integration server";
  };
}

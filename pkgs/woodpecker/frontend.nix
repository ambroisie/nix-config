{ lib, fetchFromGitHub, fetchYarnDeps, mkYarnPackage }:
let
  inherit (import ./common.nix { inherit lib fetchFromGitHub; })
    meta
    version
    src
    yarnSha256
    ;
in
mkYarnPackage {
  pname = "woodpecker-frontend";
  inherit version;

  src = "${src}/web";

  packageJSON = ./woodpecker-package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/web/yarn.lock";
    sha256 = yarnSha256;
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R deps/woodpecker-ci/dist $out
    echo "${version}" > "$out/version"

    runHook postInstall
  '';

  # Do not attempt generating a tarball for woodpecker-frontend again.
  doDist = false;

  meta = meta // {
    description = "Woodpecker Continuous Integration server frontend";
  };
}

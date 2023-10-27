{
  description = "A C++ project";

  inputs = {
    futils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "main";
    };

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    pre-commit-hooks = {
      type = "github";
      owner = "cachix";
      repo = "pre-commit-hooks.nix";
      ref = "master";
      inputs = {
        flake-utils.follows = "futils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, futils, nixpkgs, pre-commit-hooks }:
    {
      overlays = {
        default = final: _prev: {
          project = with final; buildBazelPackage {
            pname = "project";
            version = "0.0.0";

            src = self;

            inherit (pkgs) bazel;

            fetchAttrs = {
              # Fixed output derivation hash after bazel fetch.
              # This varies per platform, probably from the JDK pulled in being part
              # of the output derivation ? Is there a more robust way to do this ?
              # (Hashes extracted from the ofborg build logs)
              sha256 = let inherit (stdenv.hostPlatform) system; in {
                x86_64-linux = "${lib.fakeHash}";
              }.${system} or (throw "No hash for system: ${system}");


              # Use WORKSPACE file to fetch `rule_cc`
              removeRulesCC = false;
            };

            buildAttrs = {
              installPhase = ''
                mkdir -p "$out/bin"

                install bazel-bin/src/project "$out/bin"
              '';
            };

            doCheck = true;

            meta = with lib; {
              description = "A C++ project";
              homepage = "https://gitea.belanyi.fr/ambroisie/project";
              license = licenses.mit;
              maintainers = with maintainers; [ ambroisie ];
              platforms = platforms.unix;
            };
          };
        };
      };
    } // futils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };

        pre-commit = pre-commit-hooks.lib.${system}.run {
          src = self;

          hooks = {
            nixpkgs-fmt = {
              enable = true;
            };

            clang-format = {
              enable = true;
            };
          };
        };
      in
      {
        checks = {
          inherit (self.packages.${system}) project;

          inherit pre-commit;
        };

        devShells = {
          default = pkgs.mkShellNoCC {
            inputsFrom = with self.packages.${system}; [
              project
            ];

            packages = with pkgs; [
              clang-tools
            ];

            inherit (pre-commit) shellHook;
          };
        };

        packages = futils.lib.flattenTree {
          default = pkgs.project;
          inherit (pkgs) project;
        };
      });
}

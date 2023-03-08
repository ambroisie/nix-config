{ inputs, ... }:
{
  perSystem = { self', pkgs, ... }: {
    devShells = {
      default = pkgs.mkShell {
        name = "NixOS-config";

        nativeBuildInputs = with pkgs; [
          gitAndTools.pre-commit
          nixpkgs-fmt
        ];

        inherit (self'.checks.pre-commit) shellHook;
      };
    };
  };
}

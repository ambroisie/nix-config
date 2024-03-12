{ ... }:
{
  perSystem = { config, pkgs, ... }: {
    devShells = {
      default = pkgs.mkShellNoCC {
        name = "NixOS-config";

        nativeBuildInputs = with pkgs; [
          gitAndTools.pre-commit
          lua-language-server
          nixpkgs-fmt
        ];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}

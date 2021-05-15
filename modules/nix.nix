# Nix related settings
{ inputs, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    registry = {
      # Allow me to use my custom package using `nix run self#pkg`
      self.flake = inputs.self;
      # Do not follow master, use pinned revision instead
      nixpkgs.flake = inputs.nixpkgs;
      # Add NUR to run some packages that are only present there
      nur.flake = inputs.nur;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}

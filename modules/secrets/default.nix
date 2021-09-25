{ inputs, lib, options, ... }:

{
  imports = [
    inputs.agenix.nixosModules.age
  ];

  config.age = {
    secrets =
      let
        toName = lib.removeSuffix ".age";
        toSecret = name: _: {
          file = ./. + "/${name}";
          owner = lib.mkDefault "root";
        };
        convertSecrets = n: v: lib.nameValuePair (toName n) (toSecret n v);
        secrets = import ./secrets.nix;
      in
      lib.mapAttrs' convertSecrets secrets;

    sshKeyPaths = options.age.sshKeyPaths.default ++ [
      # FIXME: hard-coded path, could be inexistent
      "/home/ambroisie/.ssh/id_ed25519"
    ];
  };
}

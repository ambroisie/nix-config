{ inputs, lib, options, ... }:

with lib;
let
  throwOnCanary =
    let
      canaryHash = builtins.hashFile "sha256" ./canary;
      expectedHash =
        "9df8c065663197b5a1095122d48e140d3677d860343256abd5ab6e4fb4c696ab";
    in
    if canaryHash != expectedHash
    then throw "Secrets are not readable. Have you run `git-crypt unlock`?"
    else id;
in
throwOnCanary {
  imports = [
    inputs.agenix.nixosModules.age
  ];

  options.my.secrets = mkOption {
    type =
      let
        valueType = with types; oneOf [
          int
          str
          (attrsOf valueType)
          (listOf valueType)
        ];
      in
      valueType;
  };

  config.age = {
    secrets =
      let
        toName = removeSuffix ".age";
        toSecret = name: _: {
          file = ./. + "/${name}";
          owner = mkDefault "root";
        };
        convertSecrets = n: v: nameValuePair (toName n) (toSecret n v);
        secrets = import ./secrets.nix;
      in
      lib.mapAttrs' convertSecrets secrets;

    sshKeyPaths = options.age.sshKeyPaths.default ++ [
      # FIXME: hard-coded path, could be inexistent
      "/home/ambroisie/.ssh/id_ed25519"
    ];
  };

  config.my.secrets = {
    acme.key = fileContents ./acme/key.env;

    backup = {
      password = fileContents ./backup/password.txt;
      credentials = readFile ./backup/credentials.env;
    };

    drone = {
      gitea = readFile ./drone/gitea.env;
      secret = readFile ./drone/secret.env;
      ssh = {
        publicKey = readFile ./drone/ssh/key.pub;
        privateKey = readFile ./drone/ssh/key;
      };
    };

    lohr.secret = fileContents ./lohr/secret.txt;

    matrix = {
      mail = import ./matrix/mail.nix;
      secret = fileContents ./matrix/secret.txt;
    };

    miniflux.password = fileContents ./miniflux/password.txt;

    monitoring.password = fileContents ./monitoring/password.txt;

    nextcloud.password = fileContents ./nextcloud/password.txt;

    paperless = {
      password = fileContents ./paperless/password.txt;
      secretKey = fileContents ./paperless/secretKey.txt;
    };

    podgrab.password = fileContents ./podgrab/password.txt;

    sso = import ./sso { inherit lib; };

    transmission.password = fileContents ./transmission/password.txt;

    users = {
      ambroisie.hashedPassword = fileContents ./users/ambroisie/password.txt;
      root.hashedPassword = fileContents ./users/root/password.txt;
    };

    wireguard = import ./wireguard { inherit lib; };
  };
}

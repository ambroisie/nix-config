{ config, lib, ... }:
{
  imports = [
    ./accounts.nix
  ];

  config = {
    accounts.email = {
      maildirBasePath = "mail";
    };
  };
}

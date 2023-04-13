# Common secrets
let
  keys = import ../../keys;

  inherit (keys) all;
in
{
  "users/ambroisie/hashed-password.age".publicKeys = all;
  "users/root/hashed-password.age".publicKeys = all;

  "wireguard/aramis/private-key.age".publicKeys = all;
  "wireguard/milady/private-key.age".publicKeys = all;
  "wireguard/porthos/private-key.age".publicKeys = all;
  "wireguard/richelieu/private-key.age".publicKeys = all;
}

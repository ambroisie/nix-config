# Host-specific secrets
let
  keys = import ../../../../keys;

  all = [
    # Host key
    keys.hosts.porthos
    # Allow me to modify the secrets anywhere
    keys.users.ambroisie
  ];
in
{
  # Add secrets here
}

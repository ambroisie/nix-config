# Common secrets
let
  keys = import ../../keys;

  # deadnix: skip
  all = builtins.attrValues keys.users;
in
{
  # Add secrets here
}

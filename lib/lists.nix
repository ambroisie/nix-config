{ lib, ... }:
let
  inherit (lib) filter;
in
{
  # Filter a list using a predicate function after applying a map.
  #
  # mapFilter ::
  #   (value -> bool)
  #   (any -> value)
  #   [ any ]
  mapFilter = pred: f: attrs: filter pred (map f attrs);
}

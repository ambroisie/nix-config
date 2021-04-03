{ lib, ... }:
let
  inherit (lib) filterAttrs listToAttrs mapAttrs';
in
{
  # Filter a generated set of attrs using a predicate function.
  #
  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  #
  # genAttrs' ::
  #   [ values ]
  #   (value -> { name = any; value = any; })
  #   attrs
  genAttrs' = values: f: listToAttrs (map f values);
}

# Modules that are common to various module systems
# Usually with very small differences, if any, between them.
{ lib, _class, ... }:
let
  allowedClass = [
    "darwin"
    "homeManager"
    "nixos"
  ];

  allowedClassString = lib.concatStringSep ", " (builtins.map lib.escapeNixString allowedClass);
in
{
  config = {
    assertions = [
      {
        assertion = builtins.elem _class allowedClass;
        message = ''
          `_class` specialArgs must be one of ${allowedClassString}.
        '';
      }
    ];
  };
}

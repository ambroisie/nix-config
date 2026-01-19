final: prev:
let
  inherit (final) lib;
  overrides = final: prev:
    let
      hasLegacyPackage = prev ? nvim-treesitter-legacy;
    in
    {
      nvim-treesitter-textobjects-legacy = prev.nvim-treesitter-textobjects.overrideAttrs {
        dependencies = [ final.nvim-treesitter-legacy ];
      };
    } // (lib.optionalAttrs (!hasLegacyPackage) {
      nvim-treesitter-legacy = final.nvim-treesitter;
    });
in
{
  vimPlugins = prev.vimPlugins.extend (overrides);
}

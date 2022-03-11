final: prev:
let
in
{
  # FIXME: update null-ls
  vimPlugins = prev.vimPlugins.extend (self: super: {
    null-ls-nvim = super.null-ls-nvim.overrideAttrs (old: {
      version = "2022-03-11";
      src = final.fetchFromGitHub {
        owner = "jose-elias-alvarez";
        repo = "null-ls.nvim";
        rev = "1ee1da4970b3c94bed0d0250a353bff633901cd1";
        sha256 = "sha256-db9d2djNUCZzxIkycUn8Kcu4TS33w55eWxUn2OzcLas=";
      };
    });
  });
}

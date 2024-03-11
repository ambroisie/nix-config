{ vimUtils, fetchFromGitHub }:
_final: _prev:
{
  none-ls-shellcheck-nvim = vimUtils.buildVimPlugin {
    pname = "none-ls-shellcheck.nvim";
    version = "2024-02-28";
    src = fetchFromGitHub {
      owner = "gbprod";
      repo = "none-ls-shellcheck.nvim";
      rev = "1eed283a7ede771b522a0a9f30bb604f02f51d64";
      sha256 = "1hs0q9a0xwyqml0bfmplk89f1dk4nyg6aapfarnx44zqiw1183kn";
    };
    meta.homepage = "https://github.com/gbprod/none-ls-shellcheck.nvim/";
  };
}

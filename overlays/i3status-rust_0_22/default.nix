final: prev:
{
  i3status-rust_0_22 = final.i3status-rust.overrideAttrs (oa: rec {
    name = "i3status-rust-${version}";
    version = "0.22.0";

    src = final.fetchFromGitHub {
      owner = "greshake";
      repo = "i3status";
      rev = "refs/tags/v${version}";
      hash = "sha256-9Fp5k14QkV1CwLSL1nUUu6NYIpjfvI9vNJRYNqvyr3M=";
    };

    # overrideAttrs with buildRustPackage is stupid
    cargoDeps = oa.cargoDeps.overrideAttrs (_: {
      name = "${name}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-MzosatZ4yPHAdANqOBPVW2wpjnojLo9B9N9o4DtU0Iw=";
    });
  });
}

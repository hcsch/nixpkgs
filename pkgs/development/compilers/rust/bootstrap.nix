{
  stdenv,
  fetchurl,
  callPackage,
  version,
  hashes,
}:

let
  platform = stdenv.hostPlatform.rust.rustcTarget;

  src = fetchurl {
    url =
      if platform == "mipsel-unknown-linux-gnu" then
        "https://download.kenvyra.xyz/toolchains/rust-1.83.0-mipsel-unknown-linux-gnu.tar.xz"
      else
        "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "missing bootstrap url for platform ${platform}");
  };

in
callPackage ./binary.nix {
  inherit version src platform;
  versionType = "bootstrap";
}

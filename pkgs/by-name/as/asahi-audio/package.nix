{ lib, stdenv, fetchFromGitHub, lsp-plugins, bankstown-lv2 }:

stdenv.mkDerivation {
  pname = "asahi-audio";
  version = "1.8-unreleased+6428f52";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-audio";
    rev = "6428f52c56c71a28cf3bf641cd559de17d610830";
    sha256 = "sha256-OUDwdCcRrWRWOMhDCaEZ7Naw4m02O18MXgfDaRXU2sc=";
  };

  patches = [
    ./fix-wp-config-format.patch
    ./xps-15-9575.patch
  ];

  postPatch = ''
    mkdir -p firs/j-xps-15-9575
    ls -laR
    cp ${./j-xps-15-9575}/* firs/j-xps-15-9575/
    ls -laR
    sed -i "s|/usr/|$out/|g" conf/* firs/*/*
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  doBuild = false;

  passthru.requiredLv2Packages = [
    lsp-plugins
    bankstown-lv2
  ];

  meta = with lib;
    {
      description = "DSP configuration files for Apple Silicon Macs supported by the Asahi Linux project";
      homepage = "https://github.com/AsahiLinux/asahi-audio";
      maintainers = with maintainers; [ hcsch ];
      license = licenses.mit;
      platforms = platforms.linux;
    };
}

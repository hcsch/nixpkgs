{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, openssl
}:

let
  ripe-atlas-probe-measurements-printf = (fetchpatch {
    name = "ripe-atlas-probe-measurements-printf.patch";
    url = "https://github.com/RIPE-NCC/ripe-atlas-probe-measurements/pull/18/commits/e1f33691a8169f2608bc42094d3280a5d6b023fb.patch";
    hash = "sha256-VIyN8DbJSR8vo/pQ3su4s4fsBQ9Gx4fOvPK0/zm0Avs=";
  });
in
stdenv.mkDerivation rec {
  pname = "ripe-atlas-software-probe";
  version = "5090";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-s1aLjbaMbTVSy14w7uZAKU/kizLbl4fFFKUmpud0sNk=";
  };

  patches = [
    ./spool-and-conf-dir-install.patch
  ];

  postPatch = ''
    patch -d probe-busybox -p 1 < ${ripe-atlas-probe-measurements-printf}
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ];

  configureFlags = [
    "--with-user=ripe-atlas"
    "--with-group=ripe-atlas"
    "--with-measurement-user=ripe-atlas-measurement"
    "--enable-systemd"
    "--disable-chown"
    "--disable-setcap-install"
  ];

  postInstall = ''
    rm -r $out/etc
    rm -r $out/var
    mv $out/sbin $out/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "RIPE Atlas probe in software requiring no further hardware";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-software-probe";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}

{ lib, stdenv, fetchFromGitHub, makeWrapper, gnused, coreutils, bash, systemd, which, sudo, util-linux, btrfs-progs, snapper, rsync, libnotify, pv }:

stdenv.mkDerivation rec {

  version = "0.7";

  pname = "snap-sync";

  nativeBuildInputs = [ makeWrapper gnused ];
  buildInputs = [ coreutils bash systemd which sudo util-linux btrfs-progs snapper rsync libnotify pv ];

  src = fetchFromGitHub {
    owner = "baod-rate";
    repo = pname;
    rev = "276e17794064ea8f26c4e28a6c5672b5ca00fadb";

    hash = "sha256-jKoGBh8dtS9XZkUuZZcLDqreMUdyVZ16z1+Xc63TC4Q=";
  };

  patches = [ ./config-path.patch ];

  buildPhase = "true";

  installPhase = ''
    make install PREFIX="/." DESTDIR="$out" SNAPPER_CONFIG="/etc/sysconfig/snapper"
    wrapProgram $out/bin/${pname} --prefix PATH : '${lib.makeBinPath buildInputs}'
  '';

  meta = {
    description = "A tool for making backups to external drives using snapper snapshots";
    homepage = "https://github.com/baod-rate/snap-sync";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.hcsch ];
    platforms = lib.platforms.linux;
  };
}

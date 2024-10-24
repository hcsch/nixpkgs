{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, cmake
, python3
, gtest
, withAnimation ? true
, withTranscoder ? true
, eigen
, ghc_filesystem
, tinygltf
}:

let
  cmakeBool = b: if b then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  version = "1.5.5";
  pname = "draco";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = version;
    sha256 = "sha256-WYWEUfBPz/Pt7sE8snG3/LnOA3DEUm/SUVLtsH7zG5g=";
    fetchSubmodules = true;
  };

  buildInputs = [ gtest ]
    ++ lib.optionals withTranscoder [ eigen ghc_filesystem tinygltf ];

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [
    "-DDRACO_ANIMATION_ENCODING=${cmakeBool withAnimation}"
    "-DDRACO_GOOGLETEST_PATH=${gtest}"
    "-DBUILD_SHARED_LIBS=${cmakeBool true}"
    "-DDRACO_TRANSCODER_SUPPORTED=${cmakeBool withTranscoder}"
  ] ++ lib.optionals withTranscoder [
    "-DDRACO_EIGEN_PATH=${eigen}/include/eigen3"
    "-DDRACO_FILESYSTEM_PATH=${ghc_filesystem}"
    "-DDRACO_TINYGLTF_PATH=${tinygltf}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    changelog = "https://github.com/google/draco/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
}

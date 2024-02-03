{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wgsl-analyzer";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bhosTihbW89vkqp1ua0C1HGLJJdCNfRde98z4+IjkOc=";
  };

  patches = [
    ./revert-ea2c51e.patch
    ./fix-outdated-test.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "la-arena-0.3.1" = "sha256-7/bfvV5kS13zLSR8VCsmsgoWa7PHidFZTWE06zzVK5s=";
      "naga-0.14.0" = "sha256-Wo5WJzi1xdmqx23W1nuIUXkfKEzXVwL+dZu5hBOhHW8=";
    };
  };

  meta = {
    description = "A language server implementation for the WGSL shading language";
    homepage = "https://github.com/wgsl-analyzer/wgsl-analyzer";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ hcsch ];
    mainProgram = "wgsl_analyzer";
  };
}

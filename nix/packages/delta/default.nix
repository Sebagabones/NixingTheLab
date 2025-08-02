{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "delta";
  # version = "0-unstable-2023-05-13";
  src = pkgs.fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    rev = "59a907117bb9aeb467b392c4fdc36f2f931330c0";
    fetchSubmodules = true;
    # sha256 = "sha256-wi/y83rBdUI/9HKlho4/zIOHqRocw/Cb5GV2KPLaD+o=";
  };

  cargoLock = { lockFile = ./Cargo.lock; };
  meta.mainProgram = "delta";
}

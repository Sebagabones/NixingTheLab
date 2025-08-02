{ pkgs }:
pkgs.callPackage ({ rustPlatform, fetchFromGitHub, installShellFiles, pkg-config
  , oniguruma, stdenv, git, }:
  with rustPlatform;
  buildRustPackage {
    pname = "delta";
    version = "2025-08-02-main";
    src = fetchFromGitHub {
      owner = "dandavison";
      repo = "delta";
      rev = "59a907117bb9aeb467b392c4fdc36f2f931330c0";
      fetchSubmodules = true;
      sha256 = "sha256-l/9b/3dnWciBCW+4ejs1r6VTAeU+/H0ncs7QijlMzdM=";
    };
    nativeBuildInputs = [ installShellFiles pkg-config ];

    buildInputs = [ oniguruma ];

    nativeCheckInputs = [ git ];

    env = { RUSTONIG_SYSTEM_LIBONIG = true; };

    postInstall = ''
      installShellCompletion --cmd delta \
        etc/completion/completion.{bash,fish,zsh}
    '';
    cargoLock = { lockFile = ./Cargo.lock; };
    meta.mainProgram = "delta";
  }) { }

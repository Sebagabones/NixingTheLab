{ pkgs, ... }:
let
  fontmerge = pkgs.stdenv.mkDerivation {
    name = "fontmerge";
    propagatedBuildInputs = [
      (pkgs.python3.withPackages (
        pythonPackages: with pythonPackages; [
          fontforge
        ]
      ))
    ];
    dontUnpack = true;
    installPhase = "install -Dm755 ${./fontmerge.py} $out/bin/fontmerge";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "berkeley-mono-font";
  version = "20260816";

  src = ../../assests/Berkeley_Mono.zip;
  nativeBuildInputs = [
    fontmerge
    pkgs.pkg-config
    pkgs.ioskeley-mono.normal-term-NF
  ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $TMPDIR/fonts/berkeley

    ${pkgs.unzip}/bin/unzip $src -d $TMPDIR/fonts/berkeley

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype/
    mkdir -p $TMPDIR/fonts/custom/Berkeley_Mono
    fontmerge $TMPDIR/fonts/berkeley/Berkeley_Mono ${pkgs.ioskeley-mono.normal-term-NF}/share/fonts/truetype/ $TMPDIR/fonts/custom/Berkeley_Mono/BerkeleyMono
    cp -R $TMPDIR/fonts/custom $out/share/fonts/truetype/berkeley_mono



    runHook postInstall
  '';

}

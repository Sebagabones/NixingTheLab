{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "berkeley-mono-font";
  version = "20260114";

  src = ../../assests/Berkeley_Mono.zip;

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $TMPDIR/fonts/

    ${pkgs.unzip}/bin/unzip $src -d $TMPDIR/fonts/

#    shopt -s nullglob   # avoid literal *.ttf if no matches

    # for font in $TMPDIR/fonts/untouched-berkeley-mono/*.ttf; do
    # (
    #     ${pkgs.nerd-font-patcher} --careful --mono --complete --outputdir nerdfont-patch $font
    # ) &
    # done

#    wait
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    # mkdir -p  $out/share/fonts/opentype/
    # mkdir -p  $out/share/fonts/truetype/
    mkdir -p $out/share/fonts/truetype/
   # mkdir -p $out/share/fonts/truetype/berkeley_mono_nerdfont 
    # cp -R $TMPDIR/fonts $out/share/fonts/opentype/
    cp -R $TMPDIR/fonts/ $out/share/fonts/truetype/berkeley_mono
    #mv $TMPDIR/fonts/nerdfont-patch $out/share/fonts/truetype/


    runHook postInstall
  '';

}

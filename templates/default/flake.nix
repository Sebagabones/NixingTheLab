{
  description = "Python+Latex devshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell rec {
        nativeBuildInputs = [
          (pkgs.python313.withPackages (
            ps: with ps; [
              pygments
              catppuccin
              webcolors
              pdoc
              dot2tex
              webcolors
              pygments
              catppuccin
              pdoc
              dot2tex
              svg2tikz
              numpy
            ]
          ))
          (pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-basic
              dvisvgm
              dvipng # for preview and export as html
              wrapfig
              amsmath
              ulem
              hyperref
              capt-of
              fontspec
              listings
              xcolor
              koma-script
              multirow
              lstfiracode
              fvextra
              upquote
              lineno
              tcolorbox
              latexmk
              minted
              enumitem
              catppuccinpalette
              pdfcol
              caption
              latex-graphics-dev
              booktabs
              framed
              changepage
              svg
              transparent
              dot2texi
              moreverb
              xkeyval
              graphviz
              standalone
              luatex85
              pdflscape
              etoc
              titlesec
              preview
              ;
          })
          pkgs.latexminted
          pkgs.inkscape
          pkgs.pdf2svg
        ];

        shellHook = ''
          export PYTHONPATH=$(pwd)
        '';
      };
    };
}

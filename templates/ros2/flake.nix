{
  description = "ROS2 template";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs"; # IMPORTANT!!!
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-ros-overlay,
    }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell rec {
        nativeBuildInputs = [
          # (pkgs.python313.withPackages (
          #   ps: with ps; [
          #     pygments
          #     catppuccin
          #     webcolors
          #     pdoc
          #     dot2tex
          #     webcolors
          #     pygments
          #     catppuccin
          #     pdoc
          #     dot2tex
          #     svg2tikz
          #     numpy
          #   ]
          # ))
          (
            with pkgs.rosPackages.humble;
            buildEnv {
              paths = [
                ros-core
                ros-jazzy-ur
                # ... other ROS packages
              ];
            }
          )
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

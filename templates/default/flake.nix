{ pkgs }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.python313.withPackages
    (ps: [
      ps.pygments
      ps.catppuccin
      ps.webcolors
      ps.pdoc
      ps.dot2tex
      ps.webcolors
      ps.pygments
      ps.catppuccin
      ps.pdoc
      ps.dot2tex
      ps.svg2tikz
      ps.numpy
    ])
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
}

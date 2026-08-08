{
  fetchFromGitHub,
  melpaBuild,
  dash,
  lsp-mode,
  magit-section,
}:
melpaBuild {
  pname = "lean4-mode";
  version = "20260801";
  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "lean4-mode";
    rev = "1388f9d1429e38a39ab913c6daae55f6ce799479";
    sha256 = "sha256-6XFcyqSTx1CwNWqQvIc25cuQMwh3YXnbgr5cDiOCxBk=";
  };
  files = ''(:defaults "data")'';
  # elisp dependencies
  packageRequires = [
    dash
    lsp-mode
    magit-section
  ];
}

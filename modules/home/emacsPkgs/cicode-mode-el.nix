{
  fetchFromGitHub,
  melpaBuild,
  ht,
}:
melpaBuild {
  pname = "cicode-mode";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "Sebagabones";
    repo = "cicode-mode.el";
    rev = "95c4d2dd5478d3e8462ecaba49c5e399d62f7eb6";
    sha256 = "sha256-S8RhtuQfdL3OBTcxkBK1aAnGXEBMREEvVGYv3LJjwGQ=";
  };

  # elisp dependencies
  packageRequires = [
    ht
  ];
}

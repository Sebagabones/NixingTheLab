{
  fetchFromGitHub,
  melpaBuild,
  posframe,
}:
melpaBuild {
  pname = "screenshot";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "tecosaur";
    repo = "screenshot";
    rev = "2770c0cfefe1cc09d55585f4f2f336a1b26e610e";
    sha256 = "sha256-LOCDbNKx8RF13p1Z0EfQ5czcYy6tofABWL0lJR6eq1U=";
  };

  # elisp dependencies
  packageRequires = [
    posframe
  ];
}

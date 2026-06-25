{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "fsharp-ts-mode";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "bbatsov";
    repo = "fsharp-ts-mode";
    rev = "a7a4f0612456e992c5e3420b3296ed2c1d3c472c";
    sha256 = "sha256-ZdVj9xfHSaO70KSUUusfb/k8jhRxXPHR41m8R/IpHP8=";
  };
  # elisp dependencies
  packageRequires = [
  ];
}

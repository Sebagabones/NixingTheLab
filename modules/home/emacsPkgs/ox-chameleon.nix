{
  fetchFromGitHub,
  melpaBuild,
  engrave-faces,
}:
melpaBuild {
  pname = "ox-chameleon";
  version = "20260926";
  src = fetchFromGitHub {
    owner = "tecosaur";
    repo = "ox-chameleon";
    rev = "d52696836cee30eb911a57a640aee16d8fd4c015";
    sha256 = "";
  };

  # elisp dependencies
  packageRequires = [
    engrave-faces
  ];
}

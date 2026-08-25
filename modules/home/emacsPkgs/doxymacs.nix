{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "doxymacs";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "pniedzielski";
    repo = "doxymacs";
    rev = "76e32066ceb45b97e758f148a62eab6c2ca2aa78";
    sha256 = "sha256-9dWhqSlwFkIQAbiTuCwYNdvTATNbuAisFGZLd2BZI5s=";
  };

  # elisp dependencies
  packageRequires = [
  ];
}

{
  fetchFromGitHub,
  melpaBuild,
  hydra,
  transient,
}:
melpaBuild {
  pname = "uniline";
  version = "20260629";
  src = fetchFromGitHub {
    owner = "tbanel";
    repo = "uniline";
    rev = "83fb04844b8dbf0c3013996070695f02429e7915";
    sha256 = "sha256-X8yCGymTs0uBec/N+UUFlTQYYFI9a+GSUpDn+ARZwZw=";
  };

  # elisp dependencies
  packageRequires = [
    hydra
    transient
  ];
}

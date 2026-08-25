{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "comment-dwim-2";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "remyferre";
    repo = "comment-dwim-2";
    rev = "6ab75d0a690f0080e9b97c730aac817d04144cd0";
    sha256 = "sha256-ZSjkOEcpSBWkZzeVeOXyWZSIuiGCpefy1XylgXToIG0=";
  };

  # elisp dependencies
  packageRequires = [

  ];
}

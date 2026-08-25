{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "math-at-point";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "shankar2k";
    repo = "math-at-point";
    rev = "946e4d49f06198913b4404e90a16c93d945a888e";
    sha256 = "sha256-0THpgU/4+cPcbZNtP9mFNvuwrzISA5ZP2k7M8XiC2tA=";
  };

  # elisp dependencies
  packageRequires = [
  ];
}

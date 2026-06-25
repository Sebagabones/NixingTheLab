{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "org-modern-indent";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "org-modern-indent";
    rev = "ebf9a8e571db523dc6e4cd9ed80d0e0626983ae4";
    sha256 = "sha256-+q7KmbU8A+uR61BSa528vYbdFSj2WGsFWYW/5q7J9Kw=";
  };

  # elisp dependencies
  packageRequires = [
  ];
}

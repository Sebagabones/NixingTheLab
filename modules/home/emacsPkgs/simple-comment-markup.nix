{
  fetchgit,
  melpaBuild,
}:
melpaBuild {
  pname = "simple-comment-markup";
  version = "20260625";
  src = fetchgit {
    url = "https://code.tecosaur.net/tec/simple-comment-markup.git";
    rev = "d2de5265221871271e85a6838c6ec7aa0226da94";
    hash = "sha256-YX2FYBjUWyAuwC+NsUH0FTvdB3jVTJBWzQaKqp0fgAs=";
  };

  # elisp dependencies
  packageRequires = [
  ];
}

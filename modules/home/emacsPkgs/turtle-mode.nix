{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "turtle-mode";
  version = "20261018";
  src = fetchFromGitHub {
    owner = "Sebagabones";
    repo = "turtle-mode";
    rev = "4faa3461a9fd38cee14909f9a6041fff5d5c11d5";
    sha256 = "sha256-t4jmUw/ag97TD7fz4COwQnD25exXfn5+dj2C/YQs848=";
  };
}

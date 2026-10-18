{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "ttl-mode";
  version = "20261018";
  src = fetchFromGitHub {
    owner = "jeeger";
    repo = "ttl-mode";
    rev = "b3e963b280344ebbbd61095ce9d49356adf5a424";
    sha256 = "sha256-CiFmasLW6yG0kQ+A7eDOS4yZjzOWhiGGCP+ur/VlDck=";
  };

}

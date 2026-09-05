{
  fetchFromGitHub,
  melpaBuild,
}:
melpaBuild {
  pname = "d2-ts-mode";
  version = "20260905";
  src = fetchFromGitHub {
    owner = "emacsattic";
    repo = "d2-ts-mode";
    rev = "70891b8d49bbc25cc19ad9b21e3b88bda8fd705d";
    sha256 = "sha256-0x2DklhZ84tDMSjJOfe7LXKoRmoeFixDNwLFsZGJ3P4=";
  };
}

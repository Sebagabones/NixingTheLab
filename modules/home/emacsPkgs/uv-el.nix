{
  fetchFromGitHub,
  melpaBuild,
  tomlparse,
  transient,
}:
melpaBuild {

  pname = "uv";
  version = "20260625";
  src = fetchFromGitHub {
    owner = "johannes-mueller";
    repo = "uv.el";
    rev = "90f71913662982ffbac768ed5f0f6dc1d3bbd138";
    sha256 = "sha256-wLKogPmHx+xduax+gUPnsVu3aJOil68VzDDJa4FhPTM=";
  };

  # elisp dependencies
  packageRequires = [
    tomlparse
    transient
  ];
}

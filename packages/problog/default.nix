{
  pkgs,
  ...
}:

pkgs.python3Packages.buildPythonPackage (finalAttrs: {
  pname = "problog";
  version = "2.2.10";
  pyproject = true;

  src = pkgs.fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-A+SY1aGPyTNfHcT5AdhdSbMtMbtDx3WDkXMW5i3ib/g=";
  };
  # TODO: add support for SSD https://nixos.org/manual/nixpkgs/stable/#python-optional-dependencies and C2D https://github.com/ML-KULeuven/problog/blob/develop/INSTALL
  build-system = with pkgs.python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with pkgs.python3Packages; [
    pytest
  ];

  meta = {
    changelog = "https://raw.githubusercontent.com/ML-KULeuven/problog/refs/heads/master/CHANGES";
    description = "ProbLog is a Probabilistic Logic Programming Language for logic programs with probabilities.";
    homepage = "https://dtai.cs.kuleuven.be/problog/";
    license = pkgs.lib.licenses.mit;

  };
})

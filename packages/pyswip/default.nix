{
  pkgs,
  ...
}:

pkgs.python3Packages.buildPythonPackage (finalAttrs: {
  pname = "pyswip";
  version = "0.3.3";
  pyproject = true;

  src = pkgs.fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-dFzG2GBGpM+bp3WnbwDZf32RKfdRdRUig5HXOZvE/j0=";
  };

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

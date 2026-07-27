{
  description = "Python Flake Template"; # TODO:

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          PythonFlakeTemplate = pkgs.python3Packages.buildPythonPackage rec {
            # TODO:
            pname = "Python Flake Template"; # TODO:
            version = "0.0.1"; # TODO:
            pyproject = true;
            src = self;

            dependencies = with pkgs.python3Packages; [
              # TODO:
              mypy
              ast-serialize
            ];

            build-system = with pkgs.python3Packages; [
              hatch
              hatch-mypyc
              hatchling
            ];
            meta = {
              description = "A flake template for Python Projects"; # TODO:
              maintainers = [ ]; # TODO:
            };
          };
          default = self.packages.${system}.PythonFlakeTemplate;
        }
      );
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell rec {

            inputsFrom = [
              self.packages.${system}.default
            ];
            nativeBuildInputs = with pkgs; [
              uv
              ruff
              ty
              self.packages.${system}.default
            ];

            shellHook = ''
              export PYTHONPATH=$(pwd)
            '';
          };
        }
      );
    };

}

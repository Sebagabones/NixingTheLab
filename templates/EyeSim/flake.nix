{
  description = "EyeSim dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      version = "1.7.0";
      hash = "sha256-UuS711jNm8skmYsrjLDf67lOV946OBWQ5Y7ebtBcvfU=";
    in
    {

      packages.${system} = rec {
        EyeSim = pkgs.callPackage ./EyeSim.nix {
          inherit version hash;
        };
        EyeSimLib = pkgs.callPackage ./EyeSimLib.nix {
          inherit version hash;
        };
        gccsim = pkgs.callPackage ./gccsim.nix {
          inherit version hash;
        };
        default = pkgs.linkFarm "EyeSim" {
          inherit EyeSimLib EyeSim gccsim;
        };
      };
      devShells.${system}.default =
        let
          EyeSim = self.packages.x86_64-linux.EyeSim;
          EyeSimLib = self.packages.x86_64-linux.EyeSimLib;
          gccsim = self.packages.x86_64-linux.gccsim;
        in
        pkgs.mkShell {
          buildInputs = [
            EyeSim
            EyeSimLib
            gccsim
            pkgs.steam-run
            pkgs.gcc
            pkgs.libx11
            pkgs.libxext
            pkgs.libxi
            pkgs.gdb
            pkgs.libxmu
          ];

          shellHook = ''
            export CPATH=${EyeSimLib}/include:${pkgs.libx11.dev}/include:${pkgs.libxext.dev}/include:${pkgs.libxi.dev}/include:${pkgs.libxmu.dev}/include
            export LIBRARY_PATH=${EyeSimLib}/lib:${pkgs.libx11}/lib:${pkgs.libxext}/lib:${pkgs.libxi}/lib:${pkgs.libxmu}/lib
            export LD_LIBRARY_PATH=${EyeSimLib}/lib:${pkgs.libx11}/lib:${pkgs.libxext}/lib:${pkgs.libxi}/lib:${pkgs.libxmu}/lib
            export PYTHONPATH=${EyeSimLib}/lib:$PYTHONPATH
          '';
        };

    };
}

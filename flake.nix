{
  description = "Hopefully this won't go as chaotically";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = { url = "github:nixos/nixos-hardware/master"; };
    lollypops.url =
      "github:pinpox/lollypops//098b95c871a8fb6f246ead8d7072ec2201d7692b";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };
    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = inputs:
    let inherit (inputs.nixpkgs) lib;
    in inputs.blueprint {
      inherit inputs;
      systems = [ "x86_64-linux" ];
      prefix = "nix/";
      nixpkgs.config.allowUnfree = true;

    } // {

      # Lollypops
      packages."x86_64-linux".lollypops =
        inputs.lollypops.packages."x86_64-linux".default.override {
          configFlake = inputs.self;
        };

    };

}

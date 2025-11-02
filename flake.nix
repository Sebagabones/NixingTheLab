{
  description = "Hopefully this won't go as chaotically";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = { url = "github:nixos/nixos-hardware/master"; };
    lollypops.url = "github:pinpox/lollypops";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nixpkgs-stable.follows = "";
    # };
    stylix = {
      url = "github:nix-community/stylix/";
      inputs.nixpkgs.follows = "nixpkgs";

    };
    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    catppuccin.url = "github:catppuccin/nix/";
    nixcord = { url = "github:kaylorben/nixcord"; };
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

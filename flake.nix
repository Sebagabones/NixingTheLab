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
    agenix.url = "github:ryantm/agenix";
    lollypops = {
      url = "github:pinpox/lollypops";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #    microvm.url = "github:astro/microvm.nix";
    #    microvm.inputs.nixpkgs.follows = "nixpkgs";
    #    niri = {
    #      url = "github:sodiboo/niri-flake";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #      inputs.nixpkgs-stable.follows = "";
    #    };
    stylix = {
      url = "github:nix-community/stylix/";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };
    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    catppuccin.url = "github:catppuccin/nix/";
    nixcord = { url = "github:kaylorben/nixcord"; };
    mahoosivelyGay = { url = "github:Sebagabones/reallymahoosivelygay"; };
    # temp
  };

  outputs = inputs:
    let inherit (inputs.nixpkgs) lib;
    in inputs.blueprint {
      inherit inputs;
      systems = [ "x86_64-linux" ];
      nixpkgs.config.allowUnfree = true;

    } // {
      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = inputs.self;
        inherit (inputs.self) nixosConfigurations;
      };

      # Lollypops
      packages."x86_64-linux".lollypops =
        inputs.lollypops.packages."x86_64-linux".default.override {
          configFlake = inputs.self;
        };
    };
}

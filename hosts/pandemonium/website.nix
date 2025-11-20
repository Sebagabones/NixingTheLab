{ flake, inputs, lib, perSystem, pkgs, config, ... }:

let
  domain = "mahoosively.gay";
  website =
    inputs.mahoosivelyGay.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      root = "${website}/client";

    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${domain}";
    certs = {
      "${domain}" = {
        group = config.services.nginx.group;
        extraDomainNames = [ "www.${domain}" ];
      };
    };
  };
  environment.systemPackages = [ website ];

}

{
  flake,
  inputs,
  lib,
  perSystem,
  pkgs,
  config,
  ...
}:

let
  domain = "mahoosively.gay";
  website = inputs.mahoosivelyGay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  spotifyBackend = inputs.spotifyBackend.packages.${pkgs.stdenv.hostPlatform.system}.mySpotifyBackend;
  spotifyBackendExecutable = "${spotifyBackend}/bin/mySpotifyBackend";
  spotifyPort = "8007";
in
{
  age.secrets = {
    inadyn.rekeyFile = ../../secrets/inadyn.age;
    spotifyBackendConfiguration.rekeyFile = ../../secrets/reallymahoosivelygay/mySpotifyBackend/env.age;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@${domain}";
  services = {
    inadyn = {
      configFile = config.age.secrets.inadyn.path;
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        ${domain} = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            root = "${website}";
          };
        };
        "api.${domain}" = {
          forceSSL = true;
          enableACME = true;
          # useACMEHost = "api.mahoosively.gay";
          locations."/" = {
            recommendedProxySettings = false;
            proxyPass = "http://127.0.0.1:${spotifyPort}/";
            # proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig =
              #     # required when the target is also TLS server with multiple hosts
              "proxy_ssl_server_name on;"
              +
                #     # required when the server wants to use HTTP Authentication
                "proxy_pass_header Authorization;";
          };
        };
      };
    };
  };
  systemd.services.mySpotifyBackend = {
    enable = true;
    description = "SpotifyBackend API for my website";
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "2sec";
      Environment = "PORT=${spotifyPort}";
      EnvironmentFile = config.age.secrets.spotifyBackendConfiguration.path;
      ExecStart = "${spotifyBackendExecutable}";
    };
    wantedBy = [ "multi-user.target" ];
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  environment.systemPackages = [ website ];
}

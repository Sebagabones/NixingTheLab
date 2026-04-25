{
  inputs,
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
  services.harmonia = {         # TODO: At some point, move this to use agenix
    enable = true;
    signKeyPaths = [ "/var/lib/secrets/harmonia.secret" ];
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@${domain}";
  services = {
    inadyn = {
      # enable = true; TODO: Fix inadyn
      enable = false;
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
        "cache.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/".extraConfig = ''
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host $host;
            proxy_redirect http:// https://;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
          '';
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

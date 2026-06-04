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
    ddclient.rekeyFile = ../../secrets/ddclient.age;
    harmonia.rekeyFile = ../../secrets/harmonia.age;
    thymis.rekeyFile = ../../secrets/thymis.age;

    spotifyBackendConfiguration.rekeyFile = ../../secrets/reallymahoosivelygay/mySpotifyBackend/env.age;
  };

  imports = [
    inputs.thymis.nixosModules.thymis-controller
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@${domain}";
  services = {

    harmonia.cache = {
      # TODO: At some point, move this to use agenix
      enable = true;
      signKeyPaths = [ config.age.secrets.harmonia.path ];
    };

    ddclient = {
      enable = true;
      usev4 = "webv4, webv4=ipify-ipv4";
      usev6 = "";
      protocol = "namecheap";
      server = "dynamicdns.park-your-domain.com";
      domains = [
        "mahoosively.gay"
        "api.mahoosively.gay"
        "cache.mahoosively.gay"
        "thymis-testing.mahoosively.gay" # remove once youve tested this out lol
        "lab.mahoosively.gay"
        "www.mahoosively.gay"
      ];
      passwordFile = config.age.secrets.ddclient.path;
    };

    thymis-controller = {
      enable = true;
      system-binfmt-aarch64-enable = true; # Enables emulation of aarch64 binaries
      system-binfmt-x86_64-enable = false; # Enables emulation of x86_64 binaries
      # recommended-nix-gc-settings-enable = true; # Enables recommended Nix garbage collection settings
      project-path = "/var/lib/thymis"; # Directory for the project
      base-url = "https://thymis-testing.mahoosively.gay/"; # Base URL of the controller
      agent-access-url = "https://thymis-testing.mahoosively.gay/"; # URL for agents to access the controller
      auth-basic = true; # Enable basic authentication
      auth-basic-username = "admin"; # Username for basic authentication
      auth-basic-password-file = config.age.secrets.thymis.path; # File containing the password for basic authentication
      listen-host = "127.0.0.1"; # Host on which the controller listens for incoming connections
      listen-port = 8000; # Port on which the controller listens for incoming connections
      nginx-vhost-enable = true; # Whether to enable the Nginx virtual host
      nginx-vhost-name = "thymis-testing.${domain}"; # Name of the Nginx virtual host
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

        "thymis-testing.${domain}" = {
          serverName = "thymis-controller";
          enableACME = true; # Enable ACME for automatic SSL certificate management
          forceSSL = true; # Force SSL for the virtual host
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

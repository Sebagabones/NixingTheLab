{ config, pkgs, ... }:
let
  domain = import ./domain.nix;
  sso_domain = "sso.${domain}";
  inherit (config.security.acme.certs."${sso_domain}") directory;
in
{
  age.secrets = {
    kanidm = {
      rekeyFile = ../../secrets/kanidm.age;
      # mode = "770";
      owner = "kanidm";
      group = "kanidm";
    };
  };

  users = {
    users.nginx.extraGroups = [ "acme" ];
    groups.sso = {
      members = [
        config.services.nginx.group
        "nginx"
        "kanidm"
      ];
    };
  };
  security.acme.certs."${sso_domain}" = {
    domain = "${sso_domain}";
    webroot = "/var/lib/acme/${sso_domain}/acme-challenge/";
    extraDomainNames = [ "auth.${domain}" ];
    group = "sso";
    reloadServices = [
      "nginx.service"
      "kanidm.service"
    ];
    server = "https://acme-v02.api.letsencrypt.org/directory";
  };
  networking.firewall.allowedTCPPorts = [
    636
    8443
  ];

  services.kanidm = {
    package = pkgs.kanidmWithSecretProvisioning_1_11;

    client = {
      enable = true;
      settings.uri = config.services.kanidm.server.settings.origin;
    };

    server = {
      enable = true;
      settings = {
        domain = "${sso_domain}";
        origin = "https://${sso_domain}";
        tls_key = "${directory}/key.pem";
        tls_chain = "${directory}/fullchain.pem";

        # trust_x_forward_for = true;
        ldapbindaddress = "0.0.0.0:636";
        bindaddress = "[::]:8443";
      };
    };
    provision = {
      adminPasswordFile = config.age.secrets.kanidm.path;
      idmAdminPasswordFile = config.age.secrets.kanidm.path;
      enable = true;
      autoRemove = true;

      groups = {
        "test.admins" = { };
        "test.users" = { };
      };

      persons = {
        bones = {
          displayName = "Seb";
          mailAddresses = [ "seb@fakeemail.com" ];
          groups = [
            "test.admins"
            "test.users"
          ];
        };
      };

    };

  };

  services.nginx.virtualHosts."${sso_domain}" = {
    forceSSL = true;
    # enableACME = true;
    useACMEHost = "${sso_domain}";
    locations = {
      "/".extraConfig = ''
        proxy_pass ${config.services.kanidm.provision.instanceUrl};
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_pass_header X-KANIDM-OPID;
          # header_up Host {host}
          #header_up X-Real-IP {http.request.header.CF-Connecting-IP}

      '';
      "/.well-known/".root = "/var/lib/acme/${sso_domain}/acme-challenge/";

      # "/.well-known/".root = webroot_location;
    };
  };

}

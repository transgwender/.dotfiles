{ config, lib, pkgs, inputs, ... }:

let
  # https://git.shork.ch/git-mirrors/continuwuity/src/commit/6a6f8e80f144140ed14c74b54ace5357c10ac66d/nix

  # The hostname that will appear in your user and room IDs
  server_name = "robotcowgirl.farm";

  # The hostname that Continuwuity actually runs on
  #
  # This can be the same as `server_name` if you want. This is only necessary
  # when Continuwuity is running on a different machine than the one hosting your
  # root domain. This configuration also assumes this is all running on a single
  # machine, some tweaks will need to be made if this is not the case.
  matrix_hostname = "matrix.${server_name}";

  # These ones you can leave alone

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/server`
  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "${matrix_hostname}:443"
    }
  '';

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/client`
  well_known_client = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://${matrix_hostname}"
      }
    }
  '';

  # Package to use
  conduit-package = inputs.continuwuity.packages.${pkgs.system}.default;
in

{
  # Configure Continuwuity itself
  services.matrix-conduit = {
    enable = true;

    # This causes NixOS to use the flake defined in this repository instead of
    # the build of conduit built into nixpkgs.
    package = conduit-package;

    settings.global = {
      inherit server_name;
      database_backend = "rocksdb";
      allow_registration = true;
      registration_token = "@secret@";
    };
  };
  
  systemd.services.conduit.serviceConfig.ExecStart = lib.mkForce "${conduit-package}/bin/conduwuit --config /etc/matrix/config.toml";
        
  system.activationScripts."matrix-registration-token-secret" = lib.stringAfter [ "etc" "agenix" ] ''
    secret=$(cat "${config.age.secrets.matrix-registration-token.path}")
    configDir=/etc/matrix
    mkdir -p "$configDir"
    configFile=$configDir/config.toml
    ${pkgs.gnused}/bin/sed "s#@secret@#$secret#" "${config.systemd.services.conduit.environment."CONDUIT_CONFIG"}" > "$configFile"
  '';
  
  services.nginx = {  
    virtualHosts = {
      "${server_name}" = {
        locations."=/.well-known/matrix/server" = {
          # Use the contents of the derivation built previously
          alias = "${well_known_server}";

          extraConfig = ''
            # Set the header since by default NGINX thinks it's just bytes
            default_type application/json;
          '';
        };

        locations."=/.well-known/matrix/client" = {
          # Use the contents of the derivation built previously
          alias = "${well_known_client}";

          extraConfig = ''
            # Set the header since by default NGINX thinks it's just bytes
            default_type application/json;

            # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
            add_header Access-Control-Allow-Origin "*";
          '';
        };
      };

      "${matrix_hostname}" = {
        addSSL = true;
        useACMEHost = "robotcowgirl.farm";
        acmeFallbackHost = "robotcowgirl.farm";

        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "[::]";
            port = 80;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 443;
            ssl = true;
          }          {
            addr = "0.0.0.0";
            port = 8448;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 8448;
            ssl = true;
          }
        ];
        
        locations."/" = {
          proxyPass = "http://backend_conduit$request_uri";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_buffering off;
          '';
        };

        extraConfig = ''
          merge_slashes off;
        '';

      };
    };

    upstreams = {
      "backend_conduit" = {
        servers = {
          "localhost:${toString config.services.matrix-conduit.settings.global.port}" = { };
        };
      };
    };
  };

  # Open firewall ports for Matrix federation
  networking.firewall.allowedTCPPorts = [ 8448 ];
  networking.firewall.allowedUDPPorts = [ 8448 ];
}

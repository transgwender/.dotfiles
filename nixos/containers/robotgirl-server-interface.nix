{ lib, config, ... }: {
  services.nginx = {
    virtualHosts = {
      "api.robotcowgirl.farm" = {
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
          }
        ];

        locations."/" = {
          proxyPass = "http://backend_api$request_uri";
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
      "backend_api" = {
        servers = {
          "localhost:44151" = { };
        };
      };
    };
  };

  containers.robotgirl-server-interface = {
    autoStart = true;

    bindMounts = {
      "/etc/robotgirl-server-interface/config" = {
        hostPath = "/run/agenix/robotgirl-server-interface-config";
        isReadOnly = true;
      };
    };

    flake = "https://git.robotcowgirl.farm/transgwender/robotgirl-server-interface/archive/main.tar.gz";
  };
}

{ lib, config, ... }: {
  services.nginx = {  
    virtualHosts = {
      "obs.robotcowgirl.farm" = {
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
          proxyPass = "http://backend_obs$request_uri";
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
      "backend_obs" = {
        servers = {
          "localhost:8000" = { };
        };
      };
    };
  };

  containers.streemtech2obs = {
    autoStart = true;

    flake = "github:transgwender/streemtech2obs";
  };
}

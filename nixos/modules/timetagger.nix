{ config, pkgs, inputs, ... }:

{
  systemd.services.timetagger = {
    serviceConfig.Type = "simple";
    path = with pkgs; [ timetagger ];
    script = ''
      timetagger --datadir=/opt/timetagger --bind=127.0.0.1:8463 --log_level=info --credentials=jasmine:\$2a\$08\$70sG5WyIZytU7P9G.jGzAO7KXmE44GSpKSXAzWMBAzlX7fZXnl3aO
    '';    
  };

  services.nginx = {
    virtualHosts = {
      "timetagger.robotcowgirl.farm" = {
        addSSL = true;
        useACMEHost = "robotcowgirl.farm";
        acmeFallbackHost = "robotcowgirl.farm";

        locations."/" = {
          proxyPass = "http://backend_timetagger$request_uri";
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
      "backend_timetagger" = {
        servers = {
          "localhost:8082" = { };
        };
      };
    };
  };
}

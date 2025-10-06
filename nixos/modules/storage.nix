{ config, pkgs, inputs, ... }:

{
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-label/store";
    options = ["nofail"];
  };

  # Filesystem
  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "copyparty";
    settings = {
      rproxy = 1;
      xff-hdr = "cf-connecting-ip";
      e2d = true;
      unpost = 43200;
      shr = "/shares";
      e2dsa = true;
      dedup = true;
      e2ts = true;
      no-robots = true;
    };
    accounts = {
      jasmine.passwordFile = "/run/agenix/copyparty-jas-pass";
      ember.passwordFile = "/run/agenix/copyparty-emb-pass";
      astraea.passwordFile = "/run/agenix/copyparty-ast-pass";
    };
    volumes = {
      "/jasmine" = {
        path = "/mnt/storage/copyparty/jasmine";
        access = {
          A = [ "jasmine" ];
        };
        flags = {
          th-img = true;
          th-v = true;
          v-pvw = true;
        };
      };
      "/ember" = {
        path = "/mnt/storage/copyparty/ember";
        access = {
          A = [ "ember" ];
        };
        flags = {
          th-img = true;
          th-v = true;
          v-pvw = true;
        };
      };
      "/astraea" = {
        path = "/mnt/storage/copyparty/astraea";
        access = {
          A = [ "astraea" ];
        };
        flags = {
          th-img = true;
          th-v = true;
          v-pvw = true;
        };
      };
      "/music" = {
        path = "/mnt/storage/copyparty/music";
        access = {
          A = [ "jasmine" ];
          rwmd = [ "ember" "astraea" ];
          g = "*";
        };
        flags = {
          fk = 4;
        };
      };
      "/shared" = {
        path = "/mnt/storage/copyparty/shared";
        access = {
          A = [ "jasmine" ];
          rwmd = [ "ember" "astraea" ];
        };
      };
      "/public" = {
        path = "/mnt/storage/copyparty/public";
        access = {
          r = "*";
          A = [ "jasmine" ];
        };
      };
    };
  };

  # Cloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.robotcowgirl.farm";
    https = true;
    database.createLocally = true;
    maxUploadSize = "1G";
    datadir = "/mnt/storage/nextcloud";
    config.adminpassFile = "${config.age.secrets.nextcloud-admin-pass.path}";
    config.dbtype = "sqlite";

    settings.enabledPreviewProviders = [
      "OC\\Preview\\BMP"
      "OC\\Preview\\GIF"
      "OC\\Preview\\JPEG"
      "OC\\Preview\\Krita"
      "OC\\Preview\\MarkDown"
      "OC\\Preview\\MP3"
      "OC\\Preview\\OpenDocument"
      "OC\\Preview\\PNG"
      "OC\\Preview\\TXT"
      "OC\\Preview\\XBitmap"
      "OC\\Preview\\HEIC"
    ];
  };

  # Git
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    stateDir = "/mnt/storage/forgejo";
    settings = {
      server = {
        DOMAIN = "git.robotcowgirl.farm";
        ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}/";
        HTTP_PORT = 3000;
      };
      service.DISABLE_REGISTRATION = true;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };


  services.nginx = {
    virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        addSSL = true;
        useACMEHost = "robotcowgirl.farm";
        acmeFallbackHost = "robotcowgirl.farm";
      };
      "${config.services.forgejo.settings.server.DOMAIN}" = {
        addSSL = true;
        useACMEHost = "robotcowgirl.farm";
        acmeFallbackHost = "robotcowgirl.farm";
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/".proxyPass = "http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}";
      };
    };
  };
}

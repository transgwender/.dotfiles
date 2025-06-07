{ lib, config, ... }: {
  containers.blahaj-bot = {
    autoStart = true;

    bindMounts = {
      "/var/lib/ferretdb" = {
        hostPath = "/data/blahaj-bot/db";
        isReadOnly = false;
      };
      
      "/etc/blahaj-bot/token" = {
        hostPath = "/run/agenix/blahaj-bot-token";
        isReadOnly = true;
      };
    };

    flake = "github:transgwender/blahaj-bot";
  };

  containers.devhaj-bot = {
    autoStart = true;

    bindMounts = {
      "/var/lib/ferretdb" = {
        hostPath = "/data/devhaj-bot/db";
        isReadOnly = false;
      };
      
      "/etc/blahaj-bot/token" = {
        hostPath = "/run/agenix/devhaj-bot-token";
        isReadOnly = true;
      };
    };

    flake = "github:transgwender/blahaj-bot/backloggery";
  };
}

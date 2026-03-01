{ lib, config, ... }: {
  containers.blahaj-bot = {
    autoStart = true;

    bindMounts = {
      "/var/lib/ferretdb" = {
        hostPath = "/data/blahaj-bot/db";
        isReadOnly = false;
      };
      
      "/etc/blahaj-bot/config" = {
        hostPath = "/run/agenix/blahaj-bot-config";
        isReadOnly = true;
      };
    };

    flake = "https://git.robotcowgirl.farm/transgwender/blahaj-bot/archive/main.tar.gz";
  };

  containers.devhaj-bot = {
    autoStart = false;

    bindMounts = {
      "/var/lib/ferretdb" = {
        hostPath = "/data/devhaj-bot/db";
        isReadOnly = false;
      };
      
      "/etc/blahaj-bot/config" = {
        hostPath = "/run/agenix/devhaj-bot-config";
        isReadOnly = true;
      };
    };

    flake = "https://git.robotcowgirl.farm/transgwender/blahaj-bot/archive/quotes.tar.gz";
  };
}

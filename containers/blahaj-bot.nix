{ lib, config, ... }: {
  containers.devhaj-bot = {
    autoStart = true;

    bindMounts = {
      "/data/blahaj-bot" = {
        hostPath = "/data/devhaj-bot";
        isReadOnly = false;
      };
      
      "/etc/blahaj-bot/token" = {
        hostPath = "/run/agenix/blahaj-bot-token";
        isReadOnly = true;
      };
    };

    flake = "github:transgwender/blahaj-bot/db";
  };
}

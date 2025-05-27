{ ... }: {
  containers.blahaj-bot = {
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

    path = "/nix/var/nix/profiles/per-container/blahaj-bot/system";
    flake = "github:transgwender/blahaj-bot/db";

  };
}

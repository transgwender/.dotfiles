{ lib, config, ... }: {
  containers.colonH = {
    autoStart = true;

    bindMounts = {
      "/var/lib/ferretdb" = {
        hostPath = "/data/colonH/db";
        isReadOnly = false;
      };
      
      "/etc/colonH/token" = {
        hostPath = "/run/agenix/colonH-token";
        isReadOnly = true;
      };
    };

    flake = (builtins.fetchGit { url = "git@github.com:transgwender/colonH.git"; ref = "main"; rev = "677f956e33a46afc4eed512a683e16385747fe61"; }).outPath;
  };
}

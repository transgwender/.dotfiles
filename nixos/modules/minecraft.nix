{ config, pkgs, inputs, ... }:

{
  fileSystems."/mnt/minecraft" = {
    device = "/dev/disk/by-label/minecraft";
    options = ["nofail"];
  };

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/mnt/minecraft/shells";
    package = pkgs.minecraft-server;
  };
}

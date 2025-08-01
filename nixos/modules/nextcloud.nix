{ config, pkgs, inputs, ... }:

{
  fileSystems."/mnt/nextcloud" = {
    device = "/dev/disk/by-label/store";
    options = ["nofail"];
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.robotcowgirl.farm";
    https = true;
    maxUploadSize = "1G";
    datadir = "/mnt/nextcloud";
    config.adminpassFile = "${config.age.secrets.nextcloud-admin-pass.path}";
    config.dbtype = "sqlite";
  };

  services.nginx = {
    virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        addSSL = true;
        useACMEHost = "robotcowgirl.farm";
        acmeFallbackHost = "robotcowgirl.farm";
      };
    };
  };
}

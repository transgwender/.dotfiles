{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  
    virtualHosts = {
      "robotcowgirl.farm" = {
        addSSL = true;
        enableACME = true;
        root = "/var/www/robotcowgirl.farm";
      };

      "www.robotcowgirl.farm" = {
        useACMEHost = "robotcowgirl.farm";
        addSSL = true;
        globalRedirect = "robotcowgirl.farm";
      };

      "moovie.robotcowgirl.farm" = {
        # root = "/var/www/robotcowgirl.farm/testing";
        locations."/".proxyPass = "http://192.168.100.11:8096";
      };
    };
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "website@gwenkornak.ca";
    certs."robotcowgirl.farm".extraDomainNames = [
      "www.robotcowgirl.farm"
    ];
  };
}

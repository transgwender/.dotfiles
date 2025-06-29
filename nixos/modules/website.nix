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
    };
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "website@gwenkornak.ca";
  };
}

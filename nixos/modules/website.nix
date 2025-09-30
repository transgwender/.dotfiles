{ config, pkgs, ... }:

{
  # ACME data must be readable by the NGINX user
  users.users.nginx.extraGroups = [
    "acme"
  ];

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
        default = true;
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

      # "acme.robotcowgirl.farm" = {
        
      # };
    };
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "website@gwenkornak.ca";
    certs."robotcowgirl.farm".extraDomainNames = [
      "www.robotcowgirl.farm"
      "matrix.robotcowgirl.farm"
      "obs.robotcowgirl.farm"
      "cloud.robotcowgirl.farm"
      "timetagger.robotcowgirl.farm"
    ];
  };
}

{ config, pkgs, inputs, ... }:

{
	services.mealie = {
		enable = true;
		port = 9925;
	};

	services.nginx = {
		virtualHosts = {
			"mealie.robotcowgirl.farm" = {
				addSSL = true;
				useACMEHost = "robotcowgirl.farm";
				acmeFallbackHost = "robotcowgirl.farm";
				locations."/".proxyPass = "http://localhost:${toString config.services.mealie.port}";
			};
		};
	};
}

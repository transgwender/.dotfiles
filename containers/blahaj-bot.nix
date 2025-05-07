{ agenix, blahaj-bot, ... }: {

  containers.blahaj-bot = {

    autoStart = true;

    # pass the private key to the container for agenix to decrypt the secret
    bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
    
    config = { config, lib, pkgs,  ... }: {
      # system = "x86_64-linux";
    
      imports = [
        agenix.nixosModules.default
        blahaj-bot.nixosModules.x86_64-linux.default
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            blahaj-bot.overlays.x86_64-linux.default
          ];
        })
      ]; # import agenix-module into the nixos-container

      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # isn't set automatically for some reason
      
      age.secrets.blahaj-bot-token = {
        file = ../secrets/blahaj-bot-token.age;
        owner = "blahaj-bot";
      };
      
      services.blahaj-bot = {
        enable = true;
        token = config.age.secrets.blahaj-bot-token.path;
      };

      system.stateVersion = "24.11";

    };
  };
}

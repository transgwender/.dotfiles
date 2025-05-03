# { agenix, blahaj-bot, ... }: {

#   containers.blahaj-bot = {

#     autoStart = true;

#     # pass the private key to the container for agenix to decrypt the secret
#     bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
    
#     config = { config, lib, pkgs,  ... }: {
#       # system = "x86_64-linux";
    
#       imports = [
#         agenix.nixosModules.default
#         blahaj-bot.nixosModules.x86_64-linux.default
#         ({ pkgs, ... }: {
#           nixpkgs.overlays = [
#             blahaj-bot.overlays.x86_64-linux.default
#           ];
#         })
#       ]; # import agenix-module into the nixos-container

#       age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # isn't set automatically for some reason
      
#       age.secrets.blahaj-bot-token = {
#         file = ../secrets/blahaj-bot-token.age;
#         owner = "blahaj-bot";
#       };
      
#       services.blahaj-bot = {
#         enable = true;
#         token = config.age.secrets.blahaj-bot-token.path;
#       };

#       system.stateVersion = "24.11";

#     };
#   };
# }
{config, pkgs, inputs, ...}: {

  # Enable flakes
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  # Only allow this to boot as a container
  boot.isContainer = true;

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
  ];
  
  networking.hostName = "blahaj-bot";

  fileSystems."/mnt/blahaj".label = "blahaj";
  fileSystems."/mnt/blahaj/key" = {
    depends = [
      "/mnt/blahaj"
    ];
    device = "/etc/ssh";
    fsType = "none";
    options = [
      "bind"
      "ro" # The filesystem hierarchy will be read-only when accessed from /mnt/aggregator/app1
    ];
  };
  fileSystems."/mnt/blahaj/token" = {
    depends = [
      "/mnt/blahaj"
    ];
    device = "../secrets/blahaj-bot-token.age";
    fsType = "none";
    options = [
      "bind"
      "ro" # The filesystem hierarchy will be read-only when accessed from /mnt/aggregator/app1
    ];
  };

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
}

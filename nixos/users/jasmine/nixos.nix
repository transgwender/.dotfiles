{ pkgs, ... }:
{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users.users.jasmine = {
    isNormalUser = true;
      description = "jasmine";
      extraGroups = [ "networkmanager" "wheel" "docker" "media"];
      packages = with pkgs; [
        kdePackages.kate
        git
      #  thunderbird
      ];
  };

  fileSystems."/home/jasmine/Shared" = {
    depends = ["/"];
    device = "/home/shared";
    fsType = "none";
    options = ["nofail" "bind"];
  };
  
}

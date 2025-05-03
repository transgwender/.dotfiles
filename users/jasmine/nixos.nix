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
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
        kdePackages.kate
        git
      #  thunderbird
      ];
  };

  fileSystems."/home/jasmine/Storage" = {
    depends = ["/"];
    device = "/dev/disk/by-label/store-jas";
    options = ["nofail"];
  };

  fileSystems."/home/jasmine/Shared" = {
    depends = ["/"];
    device = "/home/shared";
    fsType = "none";
    options = ["nofail" "bind"];
  };
  
}

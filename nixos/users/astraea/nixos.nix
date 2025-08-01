{ pkgs, ... }:
{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users.users.astraea = {
    isNormalUser = true;
    description = "astraea";
  };

  fileSystems."/home/astraea/Shared" = {
    depends = ["/"];
    device = "/home/shared";
    fsType = "none";
    options = ["nofail" "bind"];
  };
}

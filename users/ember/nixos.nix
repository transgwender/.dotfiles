{ pkgs, ... }:
{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users.users.ember = {
    isNormalUser = true;
    description = "ember";
  };

  fileSystems."/home/ember/Storage" = {
    depends = ["/"];
    device = "/dev/disk/by-label/store-emb";
    options = ["nofail"];
  };

  fileSystems."/home/ember/Shared" = {
    depends = ["/"];
    device = "/home/shared";
    fsType = "none";
    options = ["nofail" "bind"];
  };
}

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

  fileSystems."/home/ember/OldPC/SSD" = {
    depends = ["/"];
    device = "/dev/disk/by-label/ssd";
    fsType = "ntfs-3g";
    options = ["nofail" "rw" "uid=ember"];
  };

  fileSystems."/home/ember/OldPC/HDD" = {
    depends = ["/"];
    device = "/dev/disk/by-label/hdd";
    fsType = "ntfs-3g";
    options = ["nofail" "rw" "uid=ember"];
  };
}

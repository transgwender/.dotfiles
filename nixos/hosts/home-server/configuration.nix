# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ allowed-unfree-packages, config, lib, pkgs, inputs, ... }:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };

  imports =
    [
      ../../modules/network.nix
      ../../modules/display.nix
      ../../modules/system.nix
      ../../modules/graphics.nix
      ../../modules/website.nix
      ../../modules/matrix.nix
      (builtins.fetchGit { url = "ssh://git@github.com/transgwender/media-server-config.git"; ref = "main"; rev = "d003713b5b6125b53b77d9b87d9af5e1e188afaa"; }).outPath

      ../../containers/blahaj-bot.nix
      ../../containers/streemtech2obs.nix
      
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  users.groups = {
    "media" = {
      gid = 1000;
    };
  };

  fileSystems."/media" = {
    depends = ["/"];
    device = "/dev/disk/by-label/media";
    options = ["nofail"];
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.age.secrets.wifi-pass.path
    ];

    profiles = {
      Home = {
        connection = {
          id = "home";
          type = "wifi";
          interface-name = "wlp4s0";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "$HOME_SSID";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$HOME_PSK";
        };
      };
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  # SMART Monitoring
  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/disk/by-id/nvme-WDS500G1X0E-00AFY0_204318806676"; # Main
      }
      {
        device = "/dev/disk/by-id/ata-APPLE_HDD_ST2000DM001_W8E0GEH6"; # Storage
      }
      {
        device = "/dev/disk/by-id/ata-HGST_HTS541010A9E680_JA1000CRJVL6YN"; # Media
      }
      {
        device = "/dev/disk/by-id/ata-TS128GMTS800_C696950001"; # Emb SSD
      }
    ];
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}


{ config, pkgs, inputs, ... }:

{
  
  # Enable flakes
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    cowsay
    helix
    tree
    wireguard-tools
    tcpdump
    nmap
    iptables
    xfce.tumbler
    ffmpegthumbnailer
    smartmontools
    nix-index
    inputs.agenix.packages."${system}".default
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable Root Docker
  virtualisation.docker.enable = true;

  # Disable Power Saving to ensure doesnt turn off VPN
  powerManagement.enable = false;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Blahaj-bot
  age.secrets.blahaj-bot-token = {
    file = ./../secrets/blahaj-bot-token.age;
  };

  # VPN
  age.secrets.surfshark-user-pass = {
    file = ./../secrets/surfshark-user-pass.age;
  };
}

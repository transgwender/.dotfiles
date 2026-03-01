
{ config, pkgs, ... }:

{
  networking.nat.enable = true;

  networking.nftables = {
    ruleset = ''
      table ip mullvad-nat {
        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          iifname "ve-mullvad-vpn" oifname "mv0" counter masquerade
        }
      }
    '';
  };

  containers.mullvad-vpn = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.13";

    config = { config, pkgs, lib, ... }: {
      system.stateVersion = "24.11";

      networking = {
        enableIPv6 = false;
        nameservers = [ "10.64.0.1" ];
      };
    };
  };
}

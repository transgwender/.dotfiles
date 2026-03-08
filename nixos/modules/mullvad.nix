
{ config, pkgs, ... }:

{
  networking.nat.enable = true;

  networking.nftables = {
    ruleset = ''
      table inet mullvad-nat {
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
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::3";

    config = { config, pkgs, lib, ... }: {
      system.stateVersion = "24.11";

      networking = {
        enableIPv6 = true;
        nameservers = [ "10.64.0.1" ];
      };
    };
  };
}

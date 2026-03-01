
{ config, pkgs, ... }:

{
  # Enable tailscale
  services.tailscale.enable = true;
  networking.nftables.enable = true;

  # WireGuard
  # Enable NAT
  networking.nat = {
    enable = true;
    externalInterface = "enp5s0";
    internalInterfaces = [ "wg0" ];
    enableIPv6 = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 51820 51819 ];
  };

  networking.nameservers = [ "10.64.0.1" ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward"  = 1;
    "net.ipv4.conf.mv0.rp_filter" = 2;
    "net.ipv4.conf.all.rp_filter" = 2;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp5s0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp5s0 -j MASQUERADE
      '';

      # Path to the private key file.
      privateKeyFile = "/etc/nixos/secrets/wireguard-keys/private";
      
      peers = [
        # List of allowed peers.
        { # Gwen Phone
          publicKey = "O6pL3ZbCV+5dJfiZ3WbRbO9yEFvnsZvf7hbjj92Cxlw=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # Gwen Laptop
          publicKey = "rrSRffjzM2sy3BAMMFUJx0XIBu6evQwvLcOZOzRcBGA=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
  networking.wg-quick.interfaces = {
    mv0 = {
      address = [
        "10.69.5.45/32"
      ];
      dns = [ "10.64.0.1" ];
      listenPort = 51819;
      
      privateKeyFile = "${config.age.secrets.mullvad-key.path}";
      table = "100";

      postUp = ''
        ip rule add from 10.69.5.45 table 100
        ip rule add from 192.168.100.13 table 100
        ip rule add to 192.168.100.12 lookup main priority 100
        ip rule add from 192.168.100.12 to 192.168.000.0/16 lookup main priority 100
        ip rule add from 192.168.100.12 table 100 priority 200
        ip rule add fwmark 42 table 100
      '';
      postDown = ''
        ip rule del from 10.69.5.45 table 100
        ip rule del from 192.168.100.13 table 100
        ip rule del to 192.168.100.12 lookup main priority 100
        ip rule del from 192.168.100.12 to 192.168.000.0/16 lookup main priority 100
        ip rule del from 192.168.100.12 table 100 priority 200
        ip rule del fwmark 42 table 100
      '';
      
      peers = [
          {
            publicKey = "hYbb2NQKB0g2RefngdHl3bfaLImUuzeVIv2i1VCVIlQ=";
            allowedIPs = [
              "0.0.0.0/0"
            ];
            endpoint = "104.193.135.196:51819";
            persistentKeepalive = 25;
          }
      ];
    };
  };
    
  # DNS proxy and ad-blocker
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      #Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "24c4a6c5-20ec-4ad3-8151-7446085d3319" = {
        credentialsFile = "${config.age.secrets.cloudflared-creds.path}";
        default = "http_status:404";
      };
    };
  };
}


{ config, pkgs, ... }:

{
  # Enable tailscale
  services.tailscale.enable = true;
  networking.nftables.enable = true;

  # WireGuard
  # Enable NAT
  networking.nat = {
    enable = true;
    externalInterface = "wlp4s0";
    internalInterfaces = [ "wg0" ];
    enableIPv6 = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 51820 ];
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
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE
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

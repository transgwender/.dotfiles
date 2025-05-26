{
  description = "NixOS configuration";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.lix.follows = "lix";
    };
    
    # Agenix secret manager
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };    
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      lix-module,
      lix,
      agenix,
      ...
    }: {
    nixosConfigurations = {
      nixos = let
        system = "x86_64-linux";
        users = [ "jasmine" "ember" "astraea" ];

        allowed-unfree-packages = [
          "nvidia-x11"
          "nvidia-settings"
          "nvidia-persistenced"
        ];
      in
        nixpkgs.lib.nixosSystem rec {
          inherit system;

          # Set all inputs parameters as special arguments for all submodules,
          # so you can directly use all dependencies in inputs in submodules
          specialArgs = { inherit allowed-unfree-packages inputs; };

          modules = [
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./hosts/home-server/configuration.nix
            lix-module.nixosModules.default
            agenix.nixosModules.default
          ] ++ map (user: ./users/${user}/nixos.nix) users;
        };
    };
  };
}

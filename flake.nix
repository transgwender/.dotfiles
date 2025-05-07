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

    extra-container = {
      url = "github:erikarvstedt/extra-container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Agenix secret manager
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    blahaj-bot = {
      url = "github:transgwender/blahaj-bot/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      lix-module,
      lix,
      extra-container,
      agenix,
      blahaj-bot,
      ...
    }: {
    nixosConfigurations = {
      nixos = let
         users = [ "jasmine" "ember" "astraea" ];
      in
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          # Set all inputs parameters as special arguments for all submodules,
          # so you can directly use all dependencies in inputs in submodules
          specialArgs = { inherit inputs; };

          modules = [
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./hosts/home-server/configuration.nix
            lix-module.nixosModules.default
            agenix.nixosModules.default
          ] ++ map (user: ./users/${user}/nixos.nix) users;
        };
    };
    packages.default = extra-container.lib.buildContainers {
      # The system of the container host
      system = "x86_64-linux";

      config = import ./containers/blahaj-bot.nix { agenix = inputs.agenix; blahaj-bot = inputs.blahaj-bot; };
    };
  };
}

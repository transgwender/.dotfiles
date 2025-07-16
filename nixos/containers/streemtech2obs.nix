{ lib, config, ... }: {
  containers.streemtech2obs = {
    autoStart = true;

    flake = "github:transgwender/streemtech2obs";
  };
}

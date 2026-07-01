{ config, pkgs, inputs, ... }:

{
  # networking = {
  #   firewall = {
  #     allowedTCPPorts = [ 8080 ];
  #   };

  #   nftables = {
  #     ruleset = ''
  #       table ip kimmy-nat {
  #         chain PREROUTING {
  #           type nat hook prerouting priority dstnat; policy accept;
  #           tcp dport 8080 dnat to 127.0.0.1:8080
  #         }
  #       }
  #     '';
  #   };
  # };
  environment.sessionVariables = {
    LLAMA_CACHE = "/mnt/storage/models";
  };

  services.llama-cpp = {
    enable = true;
    # modelsDir = "/mnt/storage/models";
    # model = "/mnt/storage/models/unsloth/Qwen3.5-27B-GGUF/Qwen3.5-27B-UD-Q4_K_XL.gguf";
    extraFlags = [
      "-hf" "unsloth/Qwen3.5-9B-GGUF:UD-Q4_K_XL"
      "--alias" "Qwen3.5"
      # "--mmproj" "/mnt/storage/models/unsloth/Qwen3.5-27B-GGUF/mmproj-F16.gguf"
      "--ctx-size" "16384"
      "--temp" "0.6"
      "--top-p" "0.95"
      "--top-k" "20"
      "--min-p" "0.00"
    ];
  };
}

{pkgs, ...}: let
  irs = pkgs.fetchFromGitHub {
    owner = "JackHack96";
    repo = "EasyEffects-Presets";
    rev = "834bc5007b976250190cd71937c8c22f182d2415";
    sha256 = "jMTQp2wdPOno/3FckKeOAV+ZMoalaWXIQkg+Aai3jaU=";
  };
in {
  services.easyeffects.enable = true;
  xdg.configFile = {
    "easyeffects/input/noise_reduction.json".source = ./noise_reduction.json;
    "easyeffects/irs".source = irs + "/irs";
  };
}

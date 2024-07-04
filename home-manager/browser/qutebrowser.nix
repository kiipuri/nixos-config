{
  pkgs,
  pkgs-stable,
  ...
}: {
  programs.qutebrowser = {
    enable = true;
    package = pkgs-stable.qutebrowser;
    quickmarks = {
      nixos = "https://search.nixos.org/options";
      nixpkgs = "https://github.com/NixOS/nixpkgs";
      home-manager = "https://mipmip.github.io/home-manager-option-search/";
      nixvim = "https://github.com/nix-community/nixvim";
    };
    aliases = {
      adblock-toggle = "config-cycle content.blocking.enabled";
      mpv = "spawn mpv {url}";
    };
    keyBindings = {
      normal = {
        "<Ctrl-j>" = "cmd-run-with-count 10 scroll down";
        "<Ctrl-k>" = "cmd-run-with-count 10 scroll up";
        "J" = "tab-prev";
        "K" = "tab-next";
        "<Alt+j>" = "tab-move -";
        "<Alt+k>" = "tab-move +";
      };
    };
    searchEngines = {
      DEFAULT = "https://searx.kiipuri.dev/search?q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      y = "https://www.youtube.com/results?search_query={}";
      wi = "https://en.wiktionary.org/wiki/{}";
    };
    extraConfig = ''
      config.unbind("<Ctrl+q>", mode="normal")
    '';
    settings = {
      scrolling.smooth = true;
      auto_save.session = true;
      url = {
        start_pages = "https://searx.kiipuri.dev";
      };
      content = {
        autoplay = false;
        javascript.clipboard = "access-paste";
        blocking = {
          enabled = true;
          adblock.lists = ["https://easylist.to/easylist/easylist.txt" "https://easylist.to/easylist/easyprivacy.txt" "https://easylist-downloads.adblockplus.org/easylistdutch.txt" "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt" "https://www.i-dont-care-about-cookies.eu/abp/" "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"];
        };
      };
    };
    greasemonkey = [
      (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/hoothin/UserScripts/cb96fec2e7ef4106dee0400219767a1484856323/Pagetual/pagetualRules.json";
          sha256 = "sha256-wf6ACluZlEu5rQmkG84F35NWLVpTspfEouUE77UAWAI=";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/383093/1331790/Twitch%20-%20Disable%20automatic%20video%20downscale.user.js";
          sha256 = "sha256-wkfrXB0K4EnvKFD89ZNjKX7+mAWvnG/xsB1xMc0c9OY=";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/486931/1324997/FrankerFaceZ.user.js";
          sha256 = "sha256-+FzGOmBOKeJs7Ce3NJbVpSwNmoucyVu95lyqGbUCuMM=";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://userscripts.adtidy.org/release/adguard-extra/1.0/adguard-extra.user.js";
          sha256 = "sha256-l3gLtB9kOa3NjComO0bqo1YJKEqzKmE86dxLZnQTI+8=";
        }
      )
    ];
  };
}

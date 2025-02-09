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
          url = "https://raw.githubusercontent.com/hoothin/UserScripts/cb96fec2e7ef4106dee0400219767a1484856323/Pagetual/pagetualRules.json"; # update for update-nix-fetchgit
          sha256 = "00jq02syy175lb29gcjkb8nmd4yz0p71p909mnwlp54rbc581zn1";
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
          url = "https://update.greasyfork.org/scripts/486931/1468000/FrankerFaceZ.user.js"; # update for update-nix-fetchgit
          sha256 = "115031mbjl466s2vhiqj04yydwzg8pgg0z1fsn53qc1zsnfsjaj0";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://userscripts.adtidy.org/release/adguard-extra/1.0/adguard-extra.user.js"; # update for update-nix-fetchgit
          sha256 = "0pjj5m4xk92n8ajjmxyy0054lpc1m81xggg48naimrlm4dxfm11r";
        }
      )
    ];
  };
}

{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
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
      };
    };
    searchEngines = {
      DEFAULT = "https://searx.kiipuri.dev/search?q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      y = "https://www.youtube.com/results?search_query={}";
    };
    settings = {
      scrolling.smooth = true;
      auto_save.session = true;
      url = {
        start_pages = "https://searx.kiipuri.dev";
      };
      content.blocking = {
        enabled = true;
        adblock.lists = ["https://easylist.to/easylist/easylist.txt" "https://easylist.to/easylist/easyprivacy.txt" "https://easylist-downloads.adblockplus.org/easylistdutch.txt" "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt" "https://www.i-dont-care-about-cookies.eu/abp/" "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"];
      };
    };
    greasemonkey = [
      (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/hoothin/UserScripts/master/Pagetual/pagetualRules.json";
          sha256 = "sha256-HdVNKpKiPs4lQwlqBlDnvonPkQJof/g0Pz03JfNcaj0=";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/383093/Twitch%20-%20Disable%20automatic%20video%20downscale.user.js";
          sha256 = "sha256-RJj236f5Kd0oDSUiO+D9O/k3eJOI2gMpyxzGjQupNd4=";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://cdn.frankerfacez.com/static/ffz_injector.user.js";
          sha256 = "0vl038x7mm98ghrirr5zcdv24zmhfaj7mrygcm07qs6dri99yjsl";
        }
      )
      (
        pkgs.fetchurl {
          url = "https://userscripts.adtidy.org/release/adguard-extra/1.0/adguard-extra.user.js";
          sha256 = "0xrrbj0wzwdgzdl69slnzc1mjh563sqdidyb2y3711zay7lx7iz8";
        }
      )
    ];
  };
}

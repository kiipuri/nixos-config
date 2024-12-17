{pkgs, ...}: let
  pyprland-config = ''
    [pyprland]
    plugins = [
      "scratchpads",
      "monitors",
      "toggle_dpms",
    ]

    [workspaces_follow_focus]
    max_workspaces = 9

    [expose]
    include_special = false

    [scratchpads.term]
    animation = "fromTop"
    command = "${pkgs.kitty}/bin/kitty --class kitty-dropterm"
    class = "kitty-dropterm"
    size = "80% 80%"
    margin = 150

    [scratchpads.volume]
    animation = "fromTop"
    command = "${pkgs.pavucontrol}/bin/pavucontrol"
    class = "pavucontrol"
    lazy = true
    size = "80% 80%"
    margin = 150

    [scratchpads.calc]
    animation = "fromTop"
    command = "${pkgs.qalculate-gtk}/bin/qalculate-gtk"
    class = "qalculate-gtk"
    size = "80% 80%"
    margin = 150

    [scratchpads.music]
    animation = "fromTop"
    command = "${pkgs.feishin}/bin/feishin"
    class = "feishin"
    size = "80% 80%"
    margin = 150
  '';
in {
  xdg = {
    enable = true;
    configFile = {
      pypr = {
        text = pyprland-config;
        target = "hypr/pyprland.toml";
      };
    };
  };
}

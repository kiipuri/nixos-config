{...}: {
  imports = [
    ./zsh.nix
    ./kitty.nix
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      python.symbol = "󰌠 ";
      lua.symbol = "󰢱 ";
    };
  };
}

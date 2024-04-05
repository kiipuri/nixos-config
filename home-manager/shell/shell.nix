{
  config,
  pkgs,
  username,
  hostname,
  ...
}: let
  nix-shell-prompt = ''
    nix-shell-prompt() {
      if [[ -n $IN_NIX_SHELL && -z $DIRENV_DIR ]]; then
        PS1="%{$fg[cyan]%}%~ %{$fg[red]%}(%{$fg[green]%}nix-shell%{$fg[red]%}) %{$fg[blue]%}--> "
        RPROMPT=
      fi
    }

    add-zsh-hook precmd nix-shell-prompt
  '';
  lf = ''
    lf() {
      set +m

      tmp="$(${pkgs.toybox}/bin/mktemp)"
      ${pkgs.lf}/bin/lf --last-dir-path="$tmp" "$@"
      if [ -f "$tmp" ]; then
        dir="$(${pkgs.toybox}/bin/cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
          if [ "$dir" != "$(pwd)" ]; then
            cd "$dir" || exit
          fi
        fi
      fi
    }
  '';
  initExtra = ''
    autoload -U colors && colors
    zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
    source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

    zstyle ":completion:*" menu select
    zmodload zsh/complist

    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char

    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down

    setopt autocd

    compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

    ${nix-shell-prompt}
    ${lf}
  '';
in {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    inherit initExtra;
    shellAliases = {
      sudo = "doas";
      update = "sudo nixos-rebuild switch --flake .#${hostname}";
      hmupdate = "home-manager switch --flake .#${username}@${hostname}";
      ns = "NIXPKGS_ALLOW_UNFREE=1 nix-shell";
      nsp = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p";
      l = "eza -lah";
      cat = "bat";
    };
  };
}

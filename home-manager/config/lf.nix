{pkgs, ...}: {
  programs.lf = {
    enable = true;
    settings = {
      ratios = [1 2 3];
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
      shell = "sh";
      ifs = "\\n";
    };
    commands = with pkgs; {
      clip = ''
        ''${{
          case $(${xdg-utils}/bin/xdg-mime query filetype $f) in
            image/*) ${wl-clipboard}/bin/wl-copy < $fx ;;
            *) ${wl-clipboard}/bin/wl-copy file://$fx ;;
          esac
        }}
      '';
      trash = "%${trash-cli}/bin/trash-put $fx";
      sudotrash = "sudo ${trash-cli}/bin/trash-put $fx";
      sudopaste = ''
        ''${{
          set -- $(${toybox}/bin/cat ~/.local/share/lf/files)
          mode="$1"
          shift
          case "$mode" in
            copy) sudo ${toybox}/bin/cp -r "$@" .;;
            move) sudo ${toybox}/bin/mv "$@" .;;
          esac
        }}
      '';
      open = ''
        ''${{
          test -L $f && f=$(${toybox}/bin/readlink -f $f)
          case $(${xdg-utils}/bin/xdg-mime query filetype $f) in
            text/*| \
            application/json| \
            application/x-subrip| \
            application/x-yaml| \
            application/x-shellscript) $EDITOR $fx;;
            *) for f in $fx; do ${toybox}/bin/setsid $OPENER $f > /dev/null 2> /dev/null & done;;
          esac
        }}
      '';
      unarchive = ''
        ''${{
          case "$f" in
            *.zip) ${unzip}/bin/unzip "$f" ;;
            *.tar.gz) ${toybox}/bin/tar -xzf "$f" ;;
            *.tar.bz2) ${toybox}/bin/tar -xjf "$f" ;;
            *.tar.xz) ${toybox}/bin/tar -xf "$f" ;;
            *.tar.zst) ${toybox}/bin/tar --use-compress-program=unzstd -xf "$f" ;;
            *.tar|*.tgz) ${toybox}/bin/tar -xvf "$f" ;;
            *.rar) ${unrar}/bin/unrar e "$f" ;;
            *) echo "Unsupported format" ;;
          esac
        }}
      '';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read ans
          ${toybox}/bin/mkdir $ans
        }}
      '';
      mkfile = ''
        ''${{
          printf "File Name: "
          read ans
          $EDITOR $ans
        }}
      '';
      zip = ''
        ''${{
          files=()
          absfiles=("$fx")
          for f in $absfiles; do
            bname=$(${toybox}/bin/basename $f)
            files+=($bname)
          done
          ${zip}/bin/zip -r "$f" ''${files[@]}
        }}
      '';
      z = ''
        %{{
          printf "Directory search string: "
          read dir
          result="$(zoxide query $dir)"
          ${lf}/bin/lf -remote "send ''${id} cd '$''\{result}'"
        }}
      '';
      zi = ''
        ''${{
          result="$(${zoxide}/bin/zoxide query -i -- "$1")"
          ${lf}/bin/lf -remote "send ''${id} cd '$''\{result}"
        }}
      '';
    };
    keybindings = {
      "<c-c>" = "clip";
      m = "";
      mm = "mark-save";
      ml = "mark-load";
      mr = "mark-remove";
      au = "unarchive";
      x = "trash";
      sx = "sudotrash";
      sp = "sudopaste";
      "<enter>" = "shell";
      mf = "mkfile";
      md = "mkdir";
      az = "zip";
      zz = "z";
      zi = "zi";
    };
    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        CACHE="$HOME/.cache/lf/thumbnail.$(${pkgs.coreutils}/bin/stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(${pkgs.coreutils}/bin/readlink -f "$1")" | ${pkgs.coreutils}/bin/sha256sum | ${pkgs.gawk}/bin/awk '{print $1}')"

        image() {
          ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
          exit 1
        }

        case "$(${pkgs.xdg-utils}/bin/xdg-mime query filetype "$file")" in
          image/*) image ;;

          video/*)
            [ ! -f "''${CACHE}.jpg" ] && \
              ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i "$file" -o "''${CACHE}.jpg" -s 0 -q 5
            file="''${CACHE}.jpg"
            image
          ;;

          text/markdown) ${pkgs.glow}/bin/glow -s dark $file ;;

          application/pdf)
            [ ! -f "''${CACHE}.jpg" ] &&
              ${pkgs.toybox}/bin/mkdir "$HOME/.cache/lf"
              ${pkgs.poppler_utils}/bin/pdftoppm -jpeg -f 1 -singlefile "$file" "$CACHE"
            file="''${CACHE}.jpg"
            image
          ;;
        esac

        ${pkgs.pistol}/bin/pistol "$file"
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${previewer}/bin/pv.sh
    '';
  };
}

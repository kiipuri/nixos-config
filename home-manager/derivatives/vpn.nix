{
  pkgs,
  lib,
  ...
}: let
  # rofi-shutdown = pkgs.writeShellScript "rofi-shutdown" (builtins.readFile ./scripts/rofi-shutdown);
  vpn = pkgs.writeShellScript "vpn" ''
    ACTIVE_VPN=$(nmcli -g NAME,TYPE connection show --active | awk '/:wireguard/ {sub(/:wireguard/, ""); print}')
    VPNS=$(nmcli -g NAME,TYPE connection show | awk '/:wireguard/ {sub(/:wireguard/, ""); print}')
    if [[ "$@" = "󰄬 $ACTIVE_VPN" ]]; then
      nmcli connection down "$ACTIVE_VPN" > /dev/null 2>&1 && notify-send "VPN Deactivated"
      exit 0
    elif [[ ! -z "$@" ]]; then
      nmcli connection up "$@" > /dev/null 2>&1 && notify-send "VPN Activated"
      exit 0
    else
      [[ $ACTIVE_VPN ]] && echo "󰄬 $ACTIVE_VPN" || echo $VPNS
    fi
  '';
in
  pkgs.stdenv.mkDerivation rec {
    name = "vpn-${version}";
    version = "1.0";

    nativeBuildInputs = [pkgs.makeWrapper];

    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/bin
      cp ${vpn} $out/bin/vpn
      wrapProgram $out/bin/vpn --prefix PATH : ${lib.makeBinPath [pkgs.networkmanager pkgs.gawk pkgs.libnotify]} ;
    '';
  }

{
  pkgs,
  lib,
  ...
}: let
  netuse = pkgs.writeShellScript "netuse" (builtins.readFile ./scripts/netuse);
in
  pkgs.stdenv.mkDerivation rec {
    name = "netuse-${version}";
    version = "1.0";

    nativeBuildInputs = [pkgs.makeWrapper];

    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/bin
      cp ${netuse} $out/bin/netuse
      wrapProgram $out/bin/netuse --prefix PATH : ${lib.makeBinPath [pkgs.ffmpeg pkgs.libnotify pkgs.xclip pkgs.dunst]} ;
    '';
  }

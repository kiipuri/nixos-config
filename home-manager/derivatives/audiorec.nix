{
  pkgs,
  lib,
  ...
}: let
  audiorec = pkgs.writeShellScript "audiorec" (builtins.readFile ./scripts/audio);
in
  pkgs.stdenv.mkDerivation rec {
    name = "audiorec-${version}";
    version = "1.0";

    nativeBuildInputs = [pkgs.makeWrapper];

    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/bin
      cp ${audiorec} $out/bin/audiorec
      wrapProgram $out/bin/audiorec --prefix PATH : ${lib.makeBinPath [pkgs.ffmpeg pkgs.libnotify pkgs.xclip pkgs.dunst]} ;
    '';
  }

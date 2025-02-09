{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "xcur2png";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = pname;
    rev = "aa035462d950fab35d322cb87fd2f0d702251e82";
    sha256 = "sha256-buQdGlcm6mzixs5S2hLBL8gL8w1Zo4OxLVGxNxxl0jY=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    libpng
    xorg.libX11
    xorg.libXcursor
    xorg.xorgproto
  ];

  meta = with lib; {
    homepage = "https://github.com/eworm-de/xcur2png/releases";
    description = "Convert X cursors to PNG images";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [romildo];
    mainProgram = "xcur2png";
  };
}

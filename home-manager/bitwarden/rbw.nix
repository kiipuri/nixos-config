{
  pkgs,
  secrets,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      base_url = secrets.rbw-url;
      email = "kiipuri@proton.me";
      pinentry = pkgs.pinentry-qt;
    };
  };
}

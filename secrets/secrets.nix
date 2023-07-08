let
  kiipuri = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfyXmpEhoQyfEC3L/OnMUeVVtsp1uWSh8uevVHgINAc";
  users = [kiipuri];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTenDp73EODpdS0lBY2mi4nFLMicX4vsCDa7wIQG1rs";
  systems = [system1];
in {
  "secret1.age".publicKeys = [kiipuri system1];
  "id_ed25519.age".publicKeys = [kiipuri system1];
  "password.age".publicKeys = [kiipuri system1];
  "searxng.age".publicKeys = [kiipuri system1];
}

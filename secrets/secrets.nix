let
  # kiipuri = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfyXmpEhoQyfEC3L/OnMUeVVtsp1uWSh8uevVHgINAc kiipuri01@gmail.com";
  kiipuri = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC11vHB5sRBvy6W1tg01eFKuwZoxS40fso5tVHEqI9hbHGBdc6/ZRXu03tVzsBw8MfDhYRaZSrk9KV5N+G4ofUSjbJEFz54PunWs/fEMixAzMCkXprkFIdv4yZRkeru3tHl3lcNDLhJKSOpAuuaSChaBXqwTyazQn7QBa3gKmVq2JYmqBKdyZactY3iPn98N1+zZDOYecUOiwNcuySaXIV2SukDy+fFbTMhZPryWEEO+Wnhs4QUNxdLpSl6en9U5f2goFFq6jO6Az78/e6Bd3fBD3ufH1sr77tv7+uLrXUSjY6j7paRHP4W+kb4fCbetNOU+ybK40JzIsZhqVm82FpUILB0O8zYBbPK2kHtiDaQQ8pcGwnYcWBfDP040BUoLCVOWCXdFSLjaz+IEXX9wxXg/C2sJWlJu22+NIbR+ROZL1XAT4y3qa2Soqe/KoRsHYkyv1qwI1QrGLafunyngxPT+N9KOIHg/MlX6rKGtLIZDdoR9tE5mCK6rHP+t5BIHW8= kiipuri@nixos";

  users = [kiipuri];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTenDp73EODpdS0lBY2mi4nFLMicX4vsCDa7wIQG1rs";
  systems = [system1];
in {
  "password.age".publicKeys = [kiipuri system1];
  "id_ed25519.age".publicKeys = [kiipuri system1];
  "paska.age".publicKeys = [kiipuri system1];
}

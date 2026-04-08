{ primary-user, ... }:
{
  xyz.adtya.recipes = {
    core = {
      users = {
        root-password-hash-file = "passwd/root";
        primary = {
          inherit (primary-user) name long-name email;
          password-hash-file = "passwd/${primary-user.name}";
          allowed-ssh-keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxDgoV9yf+yPnp4pt5EWgo7uC25W66ehoL/rlshVW+8 Skipper"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPodFFNUK16y9bjHVMhr+Ykro3v1FVLbmqKg7mjMv3Wz Kowalski"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxjkWuf73U2AfJajJfNl6h4/R5ko+WCI1nl9XH/9AJP Thor"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxDgoV9yf+yPnp4pt5EWgo7uC25W66ehoL/rlshVW+8 Gloria"
          ];
        };
      };
    };
  };
}

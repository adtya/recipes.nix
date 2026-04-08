{ pkgs, lib, ... }:
let
  wol-on-ethernet = pkgs.writeTextFile {
    name = "ethernet-wol-rules";
    text = ''
      ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${lib.getExe pkgs.ethtool} -s $name wol g"
    '';
    destination = "/etc/udev/rules.d/81-wol.rules";
  };
in
{
  services.udev = {
    packages = [ wol-on-ethernet ];
  };
}

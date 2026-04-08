{ pkgs, ... }:
let
  serial-tty-uaccess = pkgs.writeTextFile {
    name = "serial-tty-udev-rules";
    text = ''
      # ESP32 Serial TTY access
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0660", TAG+="uaccess"
      # Adafruit XIAO-BOOT
      SUBSYSTEM=="tty", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="810b", MODE="0660", TAG+="uaccess"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2886", ATTRS{idProduct}=="0045", MODE="0660", TAG+="uaccess"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2886", ATTRS{idProduct}=="8045", MODE="0660", TAG+="uaccess"
    '';
    destination = "/etc/udev/rules.d/70-serial-tty.rules";
  };
in
{
  services.udev = {
    packages = [ serial-tty-uaccess ];
  };
}

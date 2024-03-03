# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Common configuration
      ../../common-configuration.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-34cdb25e-1a3d-48d1-abe1-7809e8842861".device = "/dev/disk/by-uuid/34cdb25e-1a3d-48d1-abe1-7809e8842861";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-0c057e55-4c88-4ad9-bda3-944e0fdd73fd".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-34cdb25e-1a3d-48d1-abe1-7809e8842861".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "vbox-test-env"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the Gnome Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  # enable gnome systray
  environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
  # ensure gnome-settings-daemon udev rules are enabled - why?
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  # enable useful services
  services.gnome.gnome-user-share.enable = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-browser-connector.enable = true;


  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };
  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}


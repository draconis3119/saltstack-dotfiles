{ config, pkgs, ... }:

{
  imports =
    [
      ./glibc.nix
      ./hardware-configuration.nix
      ./fonts.nix
      ./yubikey.nix
    ];

  fileSystems."/".options = [ "noatime" "nodiratime" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  networking = {
    hostName = "P4X-D-NixOS";

    networkmanager.enable = true;

    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile.
  environment.systemPackages = (with pkgs; [
    ag
    alacritty
    androidsdk
    arc-theme
    asciinema
    autorandr
    blueman
    clipit
    compton
    dart
    direnv
    docker_compose
    dunst
    exercism
    flameshot
    fzf
    git
    gnome3.dconf
    gnome3.vte
    gnupg
    google-cloud-sdk
    insomnia
    jq
    lxappearance
    materia-theme
    material-icons
    networkmanagerapplet
    nitrogen
    nix-prefetch-git
    pamix
    riot-web
    slack
    terraform
    tilix
    tldr
    vim
    vlc
    vscode
    wavebox
    weechat
    wget
    yarn
    zsh
  ] ++ [
    # Web Browsers
    chromium
    firefox
  ] ++ [
    # Standard Development Tooling
    gnumake
    stdenv
  ] ++ [
    # Kubernetes
    kubectl
    kubernetes-helm
    minikube
  ] ++ [
    # Go
    dep
    go
  ] ++ [
    # Crystal Language
    crystal
    shards
  ] ++ [
    # Keybase
    kbfs
    keybase
    keybase-gui
  ] ++ [
    # i3
    i3
    i3lock
    # This is required for i3 support in polybar
    jsoncpp
    pinentry
    polybar
    rofi
  ] ++ [
    # Pony
    ponyc
    pony-stable
  ] ++ [
    # Rust
    rustup
  ]);

  environment.interactiveShellInit = ''
    if [[ "$VTE_VERSION" > 3405 ]]; then
      source "${pkgs.gnome3.vte}/etc/profile.d/vte.sh"
    fi
  '';

  programs.bash.enableCompletion = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.gnupg.agent.enable = false;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";

    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    libinput = {
      enable = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;

    android_sdk = {
      accept_license = true;
    };

    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  users.groups.rawkode = {};

  users.users.rawkode =
  { isNormalUser = true;
    home = "/home/rawkode";
    description = "David McKay";
    extraGroups = [ "rawkode" "audio" "disk" "docker" "networkmanager" "plugdev" "wheel" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableHardening = false;
      addNetworkInterface = true;
    };

    docker = {
      enable = true;
      storageDriver = "devicemapper";
    };
  };

  system.stateVersion = "18.03";
}

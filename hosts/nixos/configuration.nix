{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/disk/by-uuid/DFBD-1B06";
    fsType = lib.mkForce "vfat";
    options = lib.mkForce [ "fmask=0077" "dmask=0077" ];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  specialisation.no-nvidia.configuration = {
    system.nixos.tags = [ "no-nvidia-fallback" ];
    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
    boot.blacklistedKernelModules = lib.mkForce [ ];
    hardware.nvidia.modesetting.enable = lib.mkForce false;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
      ];
    };
  };

  systemd.user.services.fcitx5 = {
    description = "Fcitx 5 input method editor";
    wantedBy = [ "graphical-session.target" "gnome-session-wayland.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" "gnome-session-wayland.target" ];
    serviceConfig = {
      ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    liberation_ttf
    dejavu_fonts
  ];

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."qrbao" = {
    isNormalUser = true;
    description = "qrbao";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    btop
    cmake
    curl
    dconf-editor
    direnv
    eza
    fd
    flameshot
    gcc
    gh
    git
    google-chrome
    copyq
    gnome-screenshot
    gnome-tweaks
    gnumake
    go
    htop
    jq
    libnotify
    nil
    nix-output-monitor
    nodejs
    config.boot.kernelPackages.nvidia_x11.settings
    p7zip
    pciutils
    pkg-config
    pnpm
    python3
    ripgrep
    rustup
    tmux
    tree
    unzip
    usbutils
    vim
    wget
    wl-clipboard
    xclip
    xsel
    zip
  ];

  system.stateVersion = "26.05";
}

{
inputs,
config,
lib,
pkgs,
...
}: {
	imports = [
		# Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	# Boot loader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	#Networking
	networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;

	# Settings
	time.timeZone = "Europe/Copenhagen";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		keyMap = "dk";
	};
	services.xserver.xkb.layout = "dk";

	programs.niri.enable = true;

	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};
	services.displayManager.ly.enable = true;
	programs.zsh.enable = true;

	virtualisation.docker.enable = true;

	# Drivers
	hardware.graphics.enable = true;
	hardware.graphics.enable32Bit = true;
	services.xserver.videoDrivers = ["nvidia"];
	hardware.nvidia = {
		powerManagement.enable = true;
		modesetting.enable = true;
		open = true;
	};
	hardware.bluetooth.enable = true;


	# Users
	users.users.z3co = {
		isNormalUser = true;
		extraGroups = ["wheel" "docker"];
		initialPassword = "123";
		shell = pkgs.zsh;
	};

	# Security
	programs.gnupg.agent= {
		enable = true;
		enableSSHSupport = true;
		pinentryPackage = pkgs.pinentry-curses;
	};

	services.pcscd.enable = true;
	services.udev.packages = [ pkgs.yubikey-personalization ];

	# Packages
	environment.systemPackages = with pkgs; [
		yubikey-manager
		neovim
		alacritty
		fuzzel
		waybar
		swaybg
		swaylock
		swaynotificationcenter
		xwayland-satellite
		banana-cursor
		pass
		wl-clipboard
		discord
		swaylock-effects
		inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	];
	fonts.fontDir.enable = true;

	# Steam
	programs.steam.enable = true;
	programs.steam.gamescopeSession.enable = true;
	programs.gamemode.enable = true;

	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"];
	nixpkgs.config.allowUnfree = true;

	system.stateVersion = "25.11"; # Did you read the comment?
}

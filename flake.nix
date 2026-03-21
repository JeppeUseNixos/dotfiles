{
	description = "A basic flake with home-manager";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser.url = "github:youwen5/zen-browser-flake";
	};

	outputs = inputs@{self, nixpkgs, home-manager, ... }: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {inherit inputs;};
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						user.z3co = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}

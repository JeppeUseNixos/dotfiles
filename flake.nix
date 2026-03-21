{
	description = "A basic flake with home-manager";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser.url = "github:youwen5/zen-browser-flake";
		nixpkgs-freerdp.url = "github:NixOS/nixpkgs/58cc470123a6d36e2d1926679f228490a618d356";
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
						users.z3co = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
				({pkgs, ...}: {
					nixpkgs.overlays = [
						(final: prev: {
							freerdp = import inputs.nixpkgs-freerdp { system = pkgs.stdenv.hostPlatform.system; };
						})
					];
				})
			];
		};
	};
}

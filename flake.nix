# vim: shiftwidth=4 tabstop=4 noexpandtab

{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
		nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";
	};

	outputs = { self, nixpkgs, flake-utils, nixseparatedebuginfod } @ inputs:
		let
			nixosCommon = system: {
				inherit system;
				specialArgs.inputs = inputs;
				specialArgs.qyriad = self.outputs.packages.${system};
			};
		in
			# Package outputs, which we want to define for multiple systems.
			flake-utils.lib.eachDefaultSystem (system:
				let
					pkgs = import nixpkgs { inherit system; };
					qyriad = self.outputs.${system};
				in
				{
					packages = {
						xonsh = pkgs.callPackage ./nixos/pkgs/xonsh.nix { };
						nerdfonts = pkgs.callPackage ./nixos/pkgs/nerdfonts.nix { };
						udev-rules = pkgs.callPackage ./nixos/udev-rules { };
						nix-helpers = pkgs.callPackage ./nixos/pkgs/nix-helpers.nix { };
					};
				}
			)
			// # NixOS configuration outputs, which are each for one specific system.
			{
				nixosConfigurations = rec {
					futaba = nixpkgs.lib.nixosSystem (nixosCommon "x86_64-linux" // {
						modules = [
							./nixos/futaba.nix
							nixseparatedebuginfod.nixosModules.default
						];
					});
					Futaba = futaba;

					yuki = nixpkgs.lib.nixosSystem (nixosCommon "x86_64-linux" // {
						modules = [
							./nixos/yuki.nix
							nixseparatedebuginfod.nixosModules.default
						];
					});
					Yuki = yuki;
				};
			};
}

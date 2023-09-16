# vim: shiftwidth=4 tabstop=4 noexpandtab

{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
		nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";
		xonsh = {
			# FIXME: https://github.com/NixOS/nix/issues/3978
			url = "github:Qyriad/dotfiles?path=nixos/pkgs/xonsh";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, flake-utils, nixseparatedebuginfod, xonsh } @ inputs:
		let
			inherit (nixpkgs.lib.attrsets) genAttrs recursiveUpdate;
			inherit (builtins) attrNames;

			mkConfig = system: modules: nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs.inputs = inputs;
				specialArgs.qyriad = self.outputs.packages.${system};
				modules = modules ++ [
					nixseparatedebuginfod.nixosModules.default
				];
			};

			# Turns flake.${system}.packages (etc) into flake.packages (etc).
			flakeOutputsFor = flake: system: genAttrs (attrNames flake.outputs) (outputName: flake.${outputName}.${system});
		in
			# Package outputs, which we want to define for multiple systems.
			flake-utils.lib.eachDefaultSystem (system:
				let
					pkgs = import nixpkgs { inherit system; };

					qyriad = self.outputs.${system};

					non-flake-outputs = {
						packages = {
							nerdfonts = pkgs.callPackage ./nixos/pkgs/nerdfonts.nix { };
							udev-rules = pkgs.callPackage ./nixos/udev-rules { };
							nix-helpers = pkgs.callPackage ./nixos/pkgs/nix-helpers.nix { };
						};
					};
					flake-outputs = flakeOutputsFor xonsh system;
				in
				recursiveUpdate flake-outputs non-flake-outputs
			)
			// # NixOS configuration outputs, which are each for one specific system.
			{
				nixosConfigurations = rec {
					futaba = mkConfig "x86_64-linux" [
						./nixos/futaba.nix
					];
					Futaba = futaba;

					yuki = mkConfig "x86_64-linux" [
						./nixos/yuki.nix
					];
					Yuki = yuki;
				};

				# Truly dirty hack. This will let us to transparently refer to overriden or not overriden
				# packages in nixpkgs, as flake.packages.foo is preferred over flake.legacyPacakges.foo.
				legacyPackages = nixpkgs.legacyPackages;
			};
}

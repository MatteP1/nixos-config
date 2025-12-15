{ pkgs, ... }:

{
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "MatteP1";
				email = "mathiasp9999@gmail.com";
			};
			init.defaultBranch = "main";
		};
	};
}

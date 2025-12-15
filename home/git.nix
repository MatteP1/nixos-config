{ pkgs, ... }:

{
	programs.git = {
		enable = true;
		signing = {
			format = "ssh";
			key = "~/.ssh/signing-key.pub";
			# Note: the signing key must be created manually. E.g. using `ssh-keygen`.
			signByDefault = true;
		};
		settings = {
			user = {
				name = "MatteP1";
				email = "mathiasp9999@gmail.com";
			};
			init.defaultBranch = "main";
		};
	};
}

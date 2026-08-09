{ pkgs, ... }:

{
  home.packages = [ pkgs.libsecret ];

  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/signing-key.pub";
      # Note: the signing key must be created manually. E.g. using `ssh-keygen`.
      signByDefault = true;
    };

    package = pkgs.gitFull;
    settings = {
      user = {
        name = "MatteP1";
        email = "mathiasp9999@gmail.com";
      };

      init.defaultBranch = "main";
      credential.helper = "libsecret";

      # url = {
      # 	"git@github.com:".insteadOf = "https://github.com/";
      # };
    };
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      mode = "both";
    };
  };
}

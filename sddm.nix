{ pkgs, ... }: let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    # values : astronaut black_hole cyberpunk hyprland_kath jake_the_dog 
    # japanese_aesthetic pixel_sakura pixel_sakura_static post-apocalyptic_hacker purple_leaves
    embeddedTheme = "pixel_sakura";
  };

in {
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
        kdePackages.qtmultimedia
        kdePackages.qtsvg
        kdePackages.qtvirtualkeyboard
	sddm-astronaut
    ];
    theme = "sddm-astronaut-theme"; 

   /* extraPackages = [sddm-chili];
    theme = "chili";*/
  };

  environment.systemPackages = [
    sddm-astronaut
  ];
}

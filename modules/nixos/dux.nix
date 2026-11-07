{
  programs.dux-shell = {
    enable = true;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dux.service when dux-shell changes
    };
  };
}

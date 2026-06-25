import Quickshell.Hyprland._GlobalShortcuts

GlobalShortcut {
  appid: "primary-shell"
  name: "powerMenu"
  description: "Toggle power menu"
  onPressed: PowerMenuState.isPowerMenuOpen = !PowerMenuState.isPowerMenuOpen
}

import Quickshell.Hyprland._GlobalShortcuts
import "../ShellState/"

GlobalShortcut {
  appid: "primary-shell"
  name: "powerMenu"
  description: "Toggle power menu"
  onPressed: ShellState.systemSectionIndex = ShellState.mainMenuIndex
}

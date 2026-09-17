pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import "../SideBar/"
import "../MainMenu/"

Singleton {
  property bool sidebarsEnabled: true

  onSidebarsEnabledChanged: {
    SideBarState.leftOpen = false
    SideBarState.rightOpen = false
  }

  property int systemSectionIndex

  property int visibleWorkspacesAmount: Math.max(4, ...Hyprland.workspaces.values.map((it) => { return it.id }))

  property int mainMenuIndex: visibleWorkspacesAmount

  onSystemSectionIndexChanged: {
    MainMenuState.isMainMenuOpen = systemSectionIndex == mainMenuIndex
  }

}

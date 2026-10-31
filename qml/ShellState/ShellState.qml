pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import "../SideBar/"
import "../MainMenu/"
import Qt.labs.folderlistmodel

Singleton {
  id: root 

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

  property var cache: cacheFile.adapter

  FileView {
    id: cacheFile
    path: Quickshell.statePath("bolcshell.json")
    onAdapterUpdated: writeAdapter()
    onLoadFailed: error => {
      if (error == FileViewError.FileNotFound)
        writeAdapter()
    }
    adapter: JsonAdapter {
      property string lastGreeterUser: ""
      property string lastGreeterSession: ""
    }
  }

  property int selectedSessionIndex

  readonly property string selectedSessionPath: sessionFile.path

  readonly property var sessionDirs: (Quickshell.env("XDG_DATA_DIRS") || "/usr/local/share:/usr/share")
    .split(":")
    .filter(dir => dir.length > 0)
    .map(dir => dir + "/wayland-sessions")

  function collectSessions() {
    foundSessions.clear()
    const seen = new Set()
    for (let i = 0; i < scanners.count; i++) {
      const scanner = scanners.objectAt(i)
      for (let j = 0; j < scanner.count; j++) {
        const fileName = scanner.get(j, "fileName")
        if (seen.has(fileName))
          continue
        seen.add(fileName)
        foundSessions.append({ sessionPath: scanner.get(j, "filePath") })
      }
    }
  }

  property alias sessions: foundSessions

  ListModel {
    id: foundSessions
  }

  Instantiator {
    id: scanners
    model: root.sessionDirs

    delegate: FolderListModel {
      required property string modelData
      folder: "file://" + modelData
      nameFilters: ["*.desktop"]
      showDirs: false
      onCountChanged: root.collectSessions()
    }
  }


  FileView {
    id: sessionFile
    path: root.selectedSessionIndex >= 0 ? foundSessions.get(root.selectedSessionIndex).sessionPath : ""
  }

}

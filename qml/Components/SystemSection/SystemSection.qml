import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell.Hyprland
import "../Workspaces/"
import "../SystemSectionOption/"
import "../../Theme/"
import "../../ShellState/"

Row {
  spacing: 4

  Workspaces { }

  Item {
    id: newWorkspaceContainer

    height: 33
    width: expanded ? 22 : -4

    property bool expanded: false

    Behavior on width {
      NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Timer {
      id: growTimer
      interval: 500
      onTriggered: newWorkspaceContainer.expanded = true
    }

    MouseArea {
      id: newWorkspaceMouseArea

      anchors.centerIn: parent
      width: 22
      height: 33
      hoverEnabled: true

      onEntered: growTimer.restart()
      onExited: {
        growTimer.stop()
        newWorkspaceContainer.expanded = false
      }

      onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${ShellState.visibleWorkspacesAmount + 1} })`)
    }

    Image {
      visible: newWorkspaceContainer.expanded
      id: icon
      source: "../../assets/icons/plus.svg"
      width: 22;
      height: 22;

      anchors.centerIn: parent
    }

    ColorOverlay {
      visible: newWorkspaceContainer.expanded
      anchors.fill: icon
      source: icon
      color: Theme.dim
    }
  }

  SystemSectionOption {
    isUrgent: false
    icon: "../../assets/icons/moon.svg"
    highlightColor: isFocused ? Theme.colorPurple : "transparent"
    count: ShellState.mainMenuIndex
  }
}

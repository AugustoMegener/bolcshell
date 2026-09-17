pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import QtQuick
import Qt5Compat.GraphicalEffects
import "../../Theme"
import "../SystemSectionOption/"
import "../../ShellState/"

Repeater {
  model: ShellState.visibleWorkspacesAmount
  anchors.verticalCenter: parent.verticalCenter

  SystemSectionOption {
    id: workspaceOption

    required property int modelData
    property int workspaceId: modelData + 1
    property var workspaceData: Hyprland.workspaces.values.find(ws => ws.id === workspaceOption.workspaceId)

    count: modelData
    isUrgent: workspaceData ? workspaceData.urgent : false
    highlightColor:  Theme.altColor(count)
    icon: "../../" + Theme.altIcon(count)
    onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceOption.workspaceId} })`)

    Connections {
      target: workspaceOption.workspaceData
      function onFocusedChanged() {
        if (workspaceOption.workspaceData.focused) {
          ShellState.systemSectionIndex = workspaceOption.modelData
        }
      }
    }
  }
}

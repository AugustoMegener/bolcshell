import Quickshell
import QtQuick
import Quickshell.Wayland
import "../Theme"
import "."
import Qt5Compat.GraphicalEffects

PanelWindow {
  width: islandRect.width + 40
  height: islandRect.height + 40
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Bottom

  color: "transparent"

  Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    id: islandRect
    radius: 12
    color: "#1e1b18"
    border.color: Theme.activeAltColor
    width: islandContent.implicitWidth
    height: 50
    layer.enabled: true

    layer.effect: DropShadow {
      horizontalOffset: 0
      verticalOffset: 4
      radius: 16
      samples: 33
      color: "#80000000"
    }

    Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.InOutCubic } }
    Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.InOutCubic } }

    Loader {
      id: islandContent
      anchors.centerIn: parent
      source: switch (DynamicIslandState.state) {
        case DynamicIslandState.State.Idle: return "IslandState/Idle/Idle.qml"
        default: return "IslandState/Idle/Idle.qml"
      }

      Behavior on opacity { NumberAnimation { duration: 150 } }
      onSourceChanged: { opacity = 0; opacity = 1 }
    }
  }
}

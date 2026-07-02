import Quickshell
import QtQuick
import Quickshell.Wayland
import "../../../Theme"
import "../../IslandState"
import Qt5Compat.GraphicalEffects

Item {
  implicitWidth: 50
  implicitHeight: 50

  Image {
    id: icon
    anchors.centerIn: parent
    sourceSize.width: width
    sourceSize.height: height
    width: 28
    height: 28
    source: `../../../assets/icons/distros-logo/${Theme.distroId}.svg`
  }

  ColorOverlay {
    anchors.fill: icon
    source: icon
    color:  Theme.activeAltColor
  }
}

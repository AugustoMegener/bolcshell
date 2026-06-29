import QtQuick
import Quickshell.Networking 
import "../../Theme"
import Qt5Compat.GraphicalEffects

Item {
  implicitWidth: 25
  implicitHeight: 25
  visible: Networking.connectivity == NetworkConnectivity.None


  Image {
    id: icon
    width: 16
    height: 16
    anchors.centerIn: parent
    source: "../../assets/icons/globe-off.svg"

    ColorOverlay {
      anchors.fill: icon
      source: icon
      color: Theme.colorRed
    }
  }
}

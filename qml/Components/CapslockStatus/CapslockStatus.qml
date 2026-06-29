import QtQuick
import Quickshell.Io
import "../../Theme"
import Qt5Compat.GraphicalEffects

Item {
  id: root
  implicitWidth: 25
  implicitHeight: 25
  property bool capsLockOn: false
  visible: capsLockOn

Process {
  command: ["xkb-monitor", "-j"]
  running: true
  stdout: SplitParser {
    onRead: data => {
      const obj = JSON.parse(data)
      if (obj.caps !== undefined) root.capsLockOn = obj.caps
    }
  }
}

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: Theme.colorRed
    Image {
      id: icon
      width: 16
      height: 16
      anchors.centerIn: parent
      source: "../../assets/icons/case-upper.svg"
      ColorOverlay {
        anchors.fill: icon
        source: icon
        color: Theme.background
      }
    }
  }
}

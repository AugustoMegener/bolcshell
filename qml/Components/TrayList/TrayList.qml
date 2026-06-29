pragma ComponentBehavior: Bound
import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray 
import "../../Theme"
import "../TrayList"
import QtQuick.Controls


Repeater {
  id: trayList
  model: SystemTray.items

  required property var panelWindow

  Item {
    id: tray
    implicitWidth: 18
    implicitHeight: 18
    anchors.verticalCenter: parent.verticalCenter
    required property SystemTrayItem modelData

    Image {
      id: icon
      anchors.fill: parent
      source: tray.modelData.icon
    }

    QsMenuAnchor {
      id: menuAnchor
      menu: tray.modelData.menu
      anchor.item: tray
      anchor.edges: Edges.Bottom
      anchor.gravity: Edges.Bottom
    }

    MouseArea {
      id: trayMouse
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      onClicked: (event) => {
        if (event.button === Qt.RightButton && tray.modelData.hasMenu)
        menuAnchor.open()
        if (event.button === Qt.LeftButton)
        tray.modelData.activate()
        if (event.button === Qt.MiddleButton)
        tray.modelData.secondaryActivate()
      }
    }
  }
}

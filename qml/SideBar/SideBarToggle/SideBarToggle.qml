import QtQuick
import "../../Theme"
import ".."

import "../../Services/NotificationStatus/"
import "../../ShellState"

Item {
  id: sideBarToggle
  required property string side
  property bool toggle: side == "left" ? SideBarState.leftOpen : SideBarState.rightOpen

  visible: ShellState.sidebarsEnabled

  width: 33
  height: 33

  Rectangle {
    id: toggleIcon
    anchors.centerIn: parent
    anchors.horizontalCenterOffset: sideBarToggle.side == "right" ? -5 : 5
    width: 22
    height: 20
    color: "transparent"
    border.color: Theme.dim
    border.width: 1.35
    radius: 4

    Rectangle {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: sideBarToggle.side == "left" ? parent.left : undefined
      anchors.right: sideBarToggle.side == "right" ? parent.right : undefined
      anchors.topMargin: 3
      anchors.bottomMargin: 3
      anchors.leftMargin: 3
      anchors.rightMargin: 3
      width: sideBarToggle.toggle ? 5 : 3
      radius: 2
      color: Theme.dim

      Behavior on width {
        NumberAnimation { duration: 200 }
      }
    }

    Rectangle {
      visible: sideBarToggle.side == "right" && NotificationStatus.trackedNotifications.values.length > 0

      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: -width / 3
      anchors.topMargin: -height / 3

      width: 12
      height: 12
      radius: 6

      color: Theme.background

      Rectangle {

        anchors.centerIn: parent


        width: 6
        height: 6
        radius: 3

        color: Theme.activeAltColor
      }
    }

    scale: 0.7
  }

  MouseArea {
    anchors.fill: toggleIcon
    cursorShape: Qt.PointingHandCursor
    z: 2
    enabled: visible
    onPressed: {
      if (SideBarState.clickLock) return
      SideBarState.clickLock = true
      Qt.callLater(function() { SideBarState.clickLock = false })
      if (sideBarToggle.side == "left") SideBarState.leftOpen = !SideBarState.leftOpen
      else if (sideBarToggle.side == "right") SideBarState.rightOpen = !SideBarState.rightOpen
    }
  }
}

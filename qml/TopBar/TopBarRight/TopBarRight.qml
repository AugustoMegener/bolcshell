import QtQuick
import "../../SideBar/SideBarToggle"

import "../../SideBar"
import "../../Components/NetworkStatus/"
import "../../Components/CapslockStatus/"
import "../../Components/TrayList/"

Row {
    id: topBarLeft
    spacing: 8

    CapslockStatus {
      anchors.verticalCenter: parent.verticalCenter
    }

    NetworkStatus {

        anchors.verticalCenter: parent.verticalCenter
    }
  
    TrayList {
        panelWindow: Window.window
    }

    Rectangle {
      width: 2
      height: 20
      anchors.verticalCenter: parent.verticalCenter
      color: "transparent"
    }

    DateTime {
        anchors.verticalCenter: parent.verticalCenter
    }

    SideBarToggle { 
        side: "right"
        anchors.verticalCenter: parent.verticalCenter
        visible: !SideBarState.rightOpen
    }
}

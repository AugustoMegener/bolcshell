import QtQuick
import "../../SideBar/SideBarToggle"

import "../../SideBar"

Row {
    id: datetime
    spacing: 8

    DateTime {
        anchors.verticalCenter: parent.verticalCenter
    }

    SideBarToggle { 
        side: "right"
        anchors.verticalCenter: parent.verticalCenter
        visible: !SideBarState.rightOpen
    }
}

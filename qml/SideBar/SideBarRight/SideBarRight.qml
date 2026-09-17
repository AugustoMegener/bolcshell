pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../../SideBar"
import "../SideBarToggle"
import "../../Theme/"
import "../../Components/SectionBox/"
import "../../Components/QuickSettings/"
import "../../Components/BluetoothMenu/"
import "../../Services/NotificationStatus/"
import "../../Components/NotificationMenu/"

SideBar { 
  id: sidebar
  side: "right" 

  Item {
    anchors.right: parent.right
    anchors.top: parent.top

    anchors.topMargin: 15
    anchors.bottomMargin: 10
    implicitWidth: 50
    implicitHeight: 30
    SideBarToggle {
      id: toggle
      anchors.centerIn: parent
      side: "right"
      visible: SideBarState.rightOpen
    }
  }
  ColumnLayout {
    anchors.fill: parent

    anchors.topMargin: 15
    anchors.rightMargin: 10

    spacing: 8

    SectionBox {
      visible: SideBarState.rightOpen

      tabBarSizeOffset: toggle.width 
      Layout.preferredHeight: parent.height / 2

      Layout.maximumHeight: parent.height / 2
      Layout.fillWidth: true

      sections: [
        QuickSettings {
          property string icon: "../../assets/icons/sliders-horizontal.svg"
          Layout.fillWidth: true
        },

        BluetoothMenu {

          property string icon: "../../assets/icons/bluetooth.svg"
          Layout.fillWidth: true
        }
      ]
    }

    Rectangle {
      implicitHeight: 1

      Layout.fillWidth: true
      Layout.leftMargin: -5
      Layout.rightMargin: -5

      color: Theme.border
    }

    SectionBox {

      visible: SideBarState.rightOpen
      Layout.fillWidth: true
      Layout.fillHeight: true

      sections: [
        NotificationMenu {

          property string icon: "../../assets/icons/" + (NotificationStatus.trackedNotifications.values.length == 0? "bell" : "bell-dot") + ".svg"
          Layout.fillWidth: true

          Layout.fillHeight: true
        }
      ]
    }
  }
}

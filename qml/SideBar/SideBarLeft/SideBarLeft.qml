import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../SideBar"
import "../SideBarToggle"
import "../../Theme"
import "./Content"
import "../../Components/Ribbon/"

SideBar {
  id: sideBarRoot
  side: "left"


  RowLayout {
    anchors.fill: parent
    anchors.topMargin: 5
    anchors.leftMargin: 10
    anchors.bottomMargin: 10
    spacing: 10

    ColumnLayout {
      Layout.fillHeight: true
      Item {
        Layout.preferredHeight: 50
        Layout.preferredWidth: 30
        SideBarToggle {
          anchors.centerIn: parent
          side: "left"
        }
      }
      Ribbon { }
    }

    Content { }
  }
}

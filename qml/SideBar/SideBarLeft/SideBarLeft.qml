import QtQuick
import QtQuick.Layouts
import "../../SideBar"
import "../SideBarToggle"
import "../../Components/Ribbon/"
import "../../Components/TmuxSessionManager/"
import "../../Components/PowerMenu"

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
      Rectangle {

      }
      Item {
        Layout.preferredWidth: 35
        Layout.preferredHeight: 35
        Layout.alignment: Qt.AlignHCenter
        PowerMenuToggle {
          anchors.centerIn: parent
        }
      }
    }

    ColumnLayout {
      visible: SideBarState.leftOpen
      Layout.fillWidth: true


      TmuxSessionManager {
        window: sideBarRoot
        managerEnabled: SideBarState.leftOpen
        Layout.fillWidth: true   
      }

    }
  }

}

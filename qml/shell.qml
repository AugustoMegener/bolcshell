pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "./TopBar"
import "./Border"
import "./SideBar"
import "./KeyboardRgb"
import "./SideBar/SideBarLeft"
import "./SideBar/SideBarToggle"

ShellRoot { 
  id: root 

  SideBar { 
    side: "right" 

    Item {
      anchors.right: parent.right
      anchors.top: parent.top

      anchors.topMargin: 15
      anchors.rightMargin: 10
      anchors.bottomMargin: 10
      implicitWidth: 50
      implicitHeight: 30
      SideBarToggle {
        anchors.centerIn: parent
        side: "left"
      }
    }
  }

  SideBarLeft {}

  Variants {
    model: Quickshell.screens
    delegate: Component {
      Border {
        required property ShellScreen modelData
        screen: modelData
      }
    }
  }
  KeyboardRgb {}

  TopBar { }
}

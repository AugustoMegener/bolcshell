pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "./TopBar"
import "./Border"
import "./SideBar"
import "./KeyboardRgb"
import "./SideBar/SideBarLeft"
import "./SideBar/SideBarToggle"
import "./Components/PowerMenu/"

ShellRoot { 
  id: root 

  PowerMenuShortcut {} 
  PowerMenu {} 

  SideBar { 
    side: "right" 

    Item {
      anchors.right: parent.right
      anchors.top: parent.top

      anchors.topMargin: 15
      anchors.bottomMargin: 10
      implicitWidth: 50
      implicitHeight: 30
      SideBarToggle {
        anchors.centerIn: parent
        side: "right"
        visible: SideBarState.rightOpen
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

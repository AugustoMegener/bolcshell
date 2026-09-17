//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Notifications 
import QtQuick
import "./TopBar"
import "./Border"
import "./KeyboardRgb.qml"
import "./SideBar/SideBarLeft"
import "./SideBar/SideBarRight"
import "./MainMenu/"
import "./DynamicIsland/"
import "./Services/NotificationStatus/"

ShellRoot { 
  id: root 


  MainMenuShortcut {} 


  SideBarRight {

  }
  SideBarLeft {

  }

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

  TopBar {}

  MainMenu {} 

  DynamicIsland {  
    anchors { top: true } 
    margins.top: 5
  }

}

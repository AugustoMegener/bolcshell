import QtQuick

import "../Workspaces/"
import "../SystemSectionOption/"
import "../../Theme/"
import "../../ShellState/"

Row {
  spacing: 4
  Workspaces { }
  SystemSectionOption {
     isUrgent: false
     icon: "../../assets/icons/moon.svg"
     highlightColor: isFocused? Theme.colorPurple : "transparent"
     count: ShellState.mainMenuIndex

     
  }
}

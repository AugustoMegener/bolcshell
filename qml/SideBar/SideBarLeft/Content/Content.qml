import QtQuick
import QtQuick.Layouts
import "../../../SideBar"
import "../../SideBarState.qml"
import "../../../Components/TmuxSessionManager"

ColumnLayout {
  Layout.fillHeight: true
  visible: SideBarState.leftOpen

  TmuxSessionManager {}

  Item {
    Layout.fillHeight: true
  }
}

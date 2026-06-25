import QtQuick
import QtQuick.Layouts
import "../../Theme"

Item {
  Layout.topMargin: 10
  Layout.preferredHeight: 50
  Layout.fillWidth: true
  Text {
    anchors.topMargin: 15
    anchors.top: parent.top
    text: qsTr("  Tmux")
    font.family: "Bricolage Grotesque"
    font.pointSize: 18
    font.weight: Font.ExtraBold
    color: Theme.colorGreen
  }
  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 1
    color: Theme.border
  }
}

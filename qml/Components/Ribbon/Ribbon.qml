import QtQuick
import QtQuick.Layouts
import "../../Theme/"
import "../PowerMenu"

Rectangle {
  id: rootRect

  Layout.fillHeight: true
  Layout.preferredWidth: 42
  color: Theme.background
  border.color: Theme.border
  radius: 12

  PowerMenuToggle {
    anchors.bottom: parent.bottom
  }
}

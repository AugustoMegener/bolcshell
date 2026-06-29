import QtQuick
import "../../Theme/"
import Qt5Compat.GraphicalEffects
import "../PowerMenu"

Item {
  implicitWidth: 42
  implicitHeight: 42

  property bool hovered: mouse.containsMouse
  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    onClicked: { PowerMenuState.isPowerMenuOpen = !PowerMenuState.isPowerMenuOpen }
  }

  Rectangle {
    implicitWidth: 32
    implicitHeight: 32
    color: Theme.activeAltColor
    opacity: parent.hovered? 1: 0.25
    anchors.centerIn: parent



    radius: parent.hovered? parent.parent.radius * (implicitWidth / parent.parent.width) : 16

    Behavior on radius {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
  }

  Image {
    opacity: 1
    id: icon
    anchors.centerIn: parent
    source: "../../assets/icons/" + ( PowerMenuState.isPowerMenuOpen? "sun" : "moon") + ".svg"
  }

  ColorOverlay {
    anchors.fill: icon
    source: icon
    color: parent.hovered? Theme.background : Theme.activeAltColor
  }
}

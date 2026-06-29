import QtQuick
import "../../PowerMenu"
import "../../../Theme"
import Quickshell
import Qt5Compat.GraphicalEffects

Column {
  id: menuOption
  required property string label
  required property color backgroundColor
  required property string iconPath
  required property color buttonColor
  required property int buttonWidth
  required property int buttonHeight
  required property int buttonRadius
  required property string command

  Item {
    id: button

    implicitWidth: menuOption.buttonWidth
    implicitHeight: menuOption.buttonHeight

    anchors.horizontalCenter: parent.horizontalCenter

    property bool hovered: mouse.containsMouse
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            PowerMenuState.isPowerMenuOpen = false
            Quickshell.execDetached(["sh", "-c", "sleep 0.75 &&" + menuOption.command])
        }
    }

    Rectangle {
      id: bg
      implicitWidth: parent.implicitWidth - 10
      implicitHeight: parent.implicitHeight - 10
      color: menuOption.buttonColor
      opacity: parent.hovered? 1: 0.25
      anchors.centerIn: parent

      radius: parent.hovered? menuOption.buttonRadius : width / 2

      Behavior on radius {
          NumberAnimation {
              duration: 200
              easing.type: Easing.InOutQuad
          }
      }
    }

    Image {
        id: icon

        anchors.centerIn: parent

        width: bg.implicitWidth - 20
        height: bg.implicitHeight - 20

        sourceSize.width: width
        sourceSize.height: height

        source: "../../../assets/icons/" + menuOption.iconPath
    }

    ColorOverlay {
      anchors.fill: icon
      source: icon
      color: parent.hovered? menuOption.backgroundColor : menuOption.buttonColor
    }
  }

Text {
    text: qsTr(menuOption.label)
    //font.bold: true

    color: Theme.text
    font.pixelSize: 16

    width: button.width
    horizontalAlignment: Text.AlignHCenter
}
}

import QtQuick
import "../../PowerMenu"
import "../../../Theme"
import "../../../Misc/Button"
import Quickshell
import Qt5Compat.GraphicalEffects

Column {
  id: menuOption
  required property string label
  required property color backgroundColor
  required property string iconPath
  required property color buttonColor
  required property color buttonLightColor
  required property int buttonWidth
  required property int buttonHeight
  required property int buttonRadius
  required property string command


    property bool hasRadiusLeft: false
    property bool hasRadiusRight: false

  Button {

    id: button
    buttonWidth: menuOption.buttonWidth + (menuOption.hasRadiusLeft || menuOption.hasRadiusRight? 2 : 0)
    buttonHeight: menuOption.buttonHeight


    backgroundColor:  menuOption.buttonColor


    buttonInsetShadowSize: 3

    
    radiusLeft: menuOption.hasRadiusLeft? 20 : 0
    radiusRight: menuOption.hasRadiusRight? 20 : 0


    onClicked: {
        PowerMenuState.isPowerMenuOpen = false
        Quickshell.execDetached(["sh", "-c", "sleep 0.75 &&" + menuOption.command])
    }

    Item {
      width: menuOption.hasRadiusLeft ? 2 : 0
      height: 1
    }
    
    Column {

      Item {
        width: button.buttonWidth - 30
        height: button.buttonHeight - 30

        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: icon
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            sourceSize.height: height
            source: "../../../assets/icons/" + menuOption.iconPath
        }
        ColorOverlay {
          anchors.fill: icon
          source: icon
          color:  Theme.text //menuOption.buttonLightColor //Theme.dim

            opacity: 0.75
        }
      }
      /*Text {
          text: qsTr(menuOption.label)
          color: menuOption.buttonColor //Theme.text
          font.pixelSize: 12
          font.bold: true
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
        }*/
    }

    Item {
      width: menuOption.hasRadiusRight ? 2 : 0
      height: 1
    }

  }

  /*Item {
    id: button

    implicitWidth: menuOption.buttonWidth
    implicitHeight: menuOption.buttonHeight

    anchors.horizontalCenter: parent.horizontalCenter

    property bool hovered: mouse.containsMouse
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        cursorShape: Qt.PointingHandCursor
        onClicked: {
            PowerMenuState.isPowerMenuOpen = false
            Quickshell.execDetached(["sh", "-c", "sleep 0.75 &&" + menuOption.command])
        }
    }

    Rectangle {
      id: bg
      implicitWidth: parent.implicitWidth - 10
      implicitHeight: parent.implicitHeight - 10
      color: parent.hovered? menuOption.buttonColor : menuOption.buttonLightColor
      opacity: parent.hovered? 1: 0.2
      anchors.centerIn: parent

      radius: parent.hovered? menuOption.buttonRadius : width / 2

      Behavior on radius {
          NumberAnimation {
              duration: 200
              easing.type: Easing.InOutQuad
          }
      }

      Behavior on opacity {
          NumberAnimation {
              duration: 200
              easing.type: Easing.InOutQuad
          }
      }

      Behavior on color {
          ColorAnimation {
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
  }*/


}

import QtQuick
import "../../Theme/"
import Qt5Compat.GraphicalEffects
import "../PowerMenu"
import "../../Misc/Button"

Button {
  buttonHeight: 35
  buttonWidth: 35
  anchors.horizontalCenter: parent.horizontalCenter

  backgroundColor: Theme.mixColors(Theme.mainButtonColor, Theme.activeAltColor, 0.25)

  cornerRadius: 12


  Image {
    opacity: 1
    id: icon
    anchors.centerIn: parent
    source: "../../assets/icons/" + ( PowerMenuState.isPowerMenuOpen? "sun" : "moon") + ".svg"
    
        sourceSize.width: width
        sourceSize.height: height
  }

  ColorOverlay {
    anchors.fill: icon
    source: icon
    color: Theme.activeAltLightColor
  }


  onClicked: { PowerMenuState.isPowerMenuOpen = !PowerMenuState.isPowerMenuOpen }
}

/*
Item {
  implicitWidth: 42
  implicitHeight: 42

  property bool hovered: mouse.containsMouse
  MouseArea {
    id: mouse
    anchors.fill: parent

    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: { PowerMenuState.isPowerMenuOpen = !PowerMenuState.isPowerMenuOpen }
  }

  Rectangle {
    implicitWidth: 32
    implicitHeight: 32
    color: parent.hovered? Theme.activeAltColor : Theme.activeAltLightColor
    opacity: parent.hovered? 1: 0.2
    anchors.centerIn: parent



    radius: parent.hovered? parent.parent.radius * (implicitWidth / parent.parent.width) : 16

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
    opacity: 1
    id: icon
    anchors.centerIn: parent
    source: "../../assets/icons/" + ( PowerMenuState.isPowerMenuOpen? "sun" : "moon") + ".svg"
    
        sourceSize.width: width
        sourceSize.height: height
  }

  ColorOverlay {
    anchors.fill: icon
    source: icon
    color: parent.hovered? Theme.background : Theme.activeAltColor
  }
}*/

import Quickshell
import QtQuick
import Quickshell.Wayland
import "../PowerMenu"
import "../../Theme"

PanelWindow {
  id: modal
  color: "transparent"
  visible: PowerMenuState.isPowerMenuOpen || revealCircle.size > 1
  anchors { top: true; bottom: true; left: true; right: true }
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  Item {
    anchors.fill: parent

    property bool isOpen: PowerMenuState.isPowerMenuOpen
    onIsOpenChanged: {
      if (isOpen) {
        closeAnim.stop()
        cardCloseAnim.stop()
        revealCircle.size = 0
        openAnim.start()
      } else {
        openAnim.stop()
        cardOpenAnim.stop()
        cardCloseAnim.start()
      }
    }

    Rectangle {
      id: revealCircle
      property real size: 0
      property real maxSize: Math.sqrt(Screen.width * Screen.width + Screen.height * Screen.height) * 2

      width: size
      height: size
      radius: size / 2
      x: -size / 2
      y: parent.height - size / 2
      color: Theme.background
      border.color: Theme.border

      NumberAnimation {
        id: openAnim
        target: revealCircle
        property: "size"
        to: revealCircle.maxSize
        duration: 500
        easing.type: Easing.OutCubic
        onStopped: if (PowerMenuState.isPowerMenuOpen) cardOpenAnim.start()
      }

      NumberAnimation {
        id: closeAnim
        target: revealCircle
        property: "size"
        to: 0
        duration: 500
        easing.type: Easing.InCubic
      }
    }

    Rectangle {
      id: card
      anchors.centerIn: parent
      implicitWidth: 800
      implicitHeight: 180
      radius: 12
      color: Theme.foreground
      border.color: Theme.border
      opacity: 0

      transform: Translate { id: cardTranslate; y: 40 }

      NumberAnimation {
        id: cardOpenAnim
        target: cardTranslate
        property: "y"
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
        onStarted: card.opacity = 1
      }

      NumberAnimation {
        id: cardCloseAnim
        target: cardTranslate
        property: "y"
        to: 40
        duration: 300
        easing.type: Easing.InCubic
        onStopped: {
          card.opacity = 0
          cardTranslate.y = 40
          closeAnim.start()
        }
      }

      Text {
        anchors.centerIn: parent
        text: "Modal"
        color: "white"
      }
    }

    Rectangle {
      anchors.top: parent.top
      anchors.left: parent.left
      implicitWidth: 20
      implicitHeight: 20
      radius: 20
      color: "red"
      MouseArea {
        anchors.fill: parent
        onPressed: {
          PowerMenuState.isPowerMenuOpen = false
        }
      }
    }
  }
}

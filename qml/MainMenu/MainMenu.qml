import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Services.SystemTray

import "../MainMenu"
import "../Theme"
import "./PowerOption"
import "../Components/PowerManager/"

PanelWindow {
  id: modal

  color: "transparent"
  visible: MainMenuState.isMainMenuOpen || card.opacity > 0

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  
  Item {
    anchors.fill: parent

    property bool isOpen: MainMenuState.isMainMenuOpen

    onIsOpenChanged: {
      if (isOpen) {
        cardCloseAnim.stop()
        card.opacity = 0
        cardTranslate.y = 40
        cardOpenAnim.start()
        borderShader.thickness = modal.height * 1.05
      } else {
        cardOpenAnim.stop()
        cardCloseAnim.start()
        borderShader.thickness = 10.5
      }
    }


    ShaderEffect {
      id: borderShader
      anchors.fill: parent
      enabled: false
      fragmentShader: Qt.resolvedUrl("../assets/shaders/border.frag.qsb")
      property real thickness: 10.5

      Behavior on thickness {
        NumberAnimation {
          duration: 250
          easing.type: Easing.InOutCubic
        }
      }
      property real innerRadius: 12
      property real w: width
      property real h: height
      property color borderColor: Theme.background
      property real innerThickness: 1
      property color innerColor: borderWindow.hasTiledWindow? "#2b2622" : "#3d332a"
      property real shadowSize: 18
      property color shadowColor: "#BF1f1910"
    }

    PowerManager {
      id: card


  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.bottomMargin: 10


  radius: 12
  color: Theme.foreground
  border.color: Theme.border

  opacity: 0

  transform: Translate {
    id: cardTranslate
    y: 40
  }

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
    }
  }
    }
  }
}

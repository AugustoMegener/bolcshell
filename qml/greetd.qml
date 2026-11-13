pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications 
import QtQuick

import Qt5Compat.GraphicalEffects

import "./Theme"
import "./Greetd/LoginWindow/"

import "./MainMenu/PowerManager/"
import "./Theme/"

ShellRoot {
  PanelWindow {

    focusable: true

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    color: "black"

    Behavior on color {
      ColorAnimation {
        from: "black"
        to: Theme.background
        duration: 350
      }
    }

    Component.onCompleted: {
      color = Theme.background
    }


    Row {
      spacing: 10

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.margins: 15

      anchors.topMargin: -height




      Behavior on anchors.topMargin {
        NumberAnimation {
          duration: 350
          easing.type: Easing.InOutQuad
        }
      }

      Component.onCompleted: {
        anchors.topMargin = 15
      }

      SystemClock {
        id: clock
        precision: SystemClock.Seconds
      }

      Row {
        spacing: 4

        Item {
          width: 19
          height: 19
          anchors.verticalCenter: parent.verticalCenter

          Image {
            id: calendarIcon
            source: "./assets/icons/calendar.svg"
            anchors.fill: parent
          }

          ColorOverlay {
            anchors.fill: calendarIcon
            source: calendarIcon
            color: Theme.dim
          }
        }

        Text {
          text: Qt.formatDateTime(clock.date, "yyyy·MM·dd")

          color: Theme.dim
          font.pixelSize: 18
        }
      }

      Row {
        spacing: 4

        Item {
          width: 19
          height: 19
          anchors.verticalCenter: parent.verticalCenter

          Image {
            id: clockIcon
            source: "./assets/icons/clock.svg"
            anchors.fill: parent
          }

          ColorOverlay {
            anchors.fill: clockIcon
            source: clockIcon
            color: Theme.dim
          }
        }



        Text {
          text: Qt.formatDateTime(clock.date, "h'h'mm")

          color: Theme.dim
          font.pixelSize: 18
        }
      }
    }


    LoginWindow {
      anchors.centerIn: parent
      width: 100

      opacity: 0

      Behavior on width {
        NumberAnimation {
          duration: 350
          easing.type: Easing.InOutQuad
        }
      }

      Behavior on height {
        NumberAnimation {
          duration: 35
          easing.type: Easing.InOutQuad
        }
      }


      Behavior on opacity {
        NumberAnimation {
          duration: 350
          easing.type: Easing.InOutQuad
        }
      }

      Component.onCompleted: {
        width = 450
        opacity = 1
      }

    }

    PowerManager {
      id: card


      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter

      anchors.bottomMargin: -height

      Behavior on anchors.bottomMargin {
        NumberAnimation {
          duration: 350
          easing.type: Easing.InOutQuad
        }
      }

      Component.onCompleted: {
        anchors.bottomMargin = 15
      }

      radius: 12
      color: Theme.foreground
      border.color: Theme.border

      simple: true
    }
  }
}

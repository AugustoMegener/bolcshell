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

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    color: Theme.background


    Column {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.margins: 10


      SystemClock {
        id: clock
        precision: SystemClock.Seconds
      }

      Row {
        spacing: 4

        Item {
          width: 20
          height: 20
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
          font.pixelSize: 19
        }
      }

      Row {
        spacing: 4

        Item {
          width: 20
          height: 20
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
          font.pixelSize: 19
        }
      }
    }

    LoginWindow {}

    PowerManager {
      id: card


      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottomMargin: 10


      radius: 12
      color: Theme.foreground
      border.color: Theme.border

      opacity: 0

      simple: true
    }
  }
}

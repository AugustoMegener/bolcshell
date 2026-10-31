import Quickshell
import QtQuick
import "../../Theme"
import Qt5Compat.GraphicalEffects

Row {

  spacing: 8;

   

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Row {
    spacing: 4

    Item {
      width: 15
      height: 15
      anchors.verticalCenter: parent.verticalCenter

      Image {
        id: calendarIcon
        source: "../../assets/icons/calendar.svg"
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
      font.pixelSize: 14
    }
  }

  Row {
    spacing: 4

    Item {
      width: 15
      height: 15
      anchors.verticalCenter: parent.verticalCenter

      Image {
        id: clockIcon
        source: "../../assets/icons/clock.svg"
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
      font.pixelSize: 14
    }
  }
}

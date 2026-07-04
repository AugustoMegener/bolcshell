import "../../Theme"
import "./TmuxSessionCard"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

Item {
  id: sessionManager
  required property QtObject window
  required property bool managerEnabled
  Layout.topMargin: 10
  Layout.fillWidth: true
  Layout.fillHeight: true

  Text {
    id: title
    anchors.topMargin: 15
    anchors.top: parent.top
    text: qsTr("  Tmux")
    font.family: "Bricolage Grotesque"
    font.pointSize: 18
    font.weight: Font.ExtraBold
    color: Theme.colorGreen
  }

  Rectangle {
    id: div
    anchors.top: title.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
    color: Theme.border
  }

  property var sessions: []

  onVisibleChanged: {
    tmuxLs.running = sessionManager.visible
  }

  Process {
    id: tmuxLs
    command: ["tmux", "list-sessions", "-F", "#{session_name}|#{session_windows}|#{session_created}|#{session_attached}"]
    running: sessionManager.visible
    onRunningChanged: if (!running) running = sessionManager.visible
    stdout: StdioCollector {
      onStreamFinished: {
        sessionManager.sessions = text.trim().split("\n").filter(l => l.length > 0).map(line => {
          const parts = line.split("|")
          return {
            name: parts[0],
            windows: parseInt(parts[1]),
            created: parseInt(parts[2]),
            attached: parts[3] === "1"
          }
        })
      }
    }
  }

  Flickable {
    id: content
    anchors.top: div.bottom
    anchors.topMargin: 5
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    clip: true
    contentHeight: column.height


    ScrollBar.vertical: ScrollBar {
      policy: ScrollBar.AsNeeded

      contentItem: Rectangle {
        color: Theme.dim
        opacity: 0.5
        implicitWidth: 5
        radius: 5
        visible: parent.active && (contentHeight <= content.height)
      }
    }

    Column {
      id: column
      width: parent.width
      spacing: 5
      topPadding: 5
      leftPadding: 5
      bottomPadding: 5

      Repeater {
        model: sessionManager.sessions.length 
        TmuxSessionCard {
          id: card

          sessionName: sessionManager.sessions[card.index].name
          sessionWindows: sessionManager.sessions[card.index].windows
          sessionAttached: sessionManager.sessions[card.index].attached

          width: column.width - 20
          height: 100
        }
      }
    }


    Rectangle {
      anchors.top: parent.bottom
      anchors.topMargin: 5 
      anchors.left: parent.left
      anchors.right: parent.right
      height: 1
      color: Theme.border
    }
  }
}

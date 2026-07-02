import "../../Shapes/DragCardShape"
import "../../Theme"
import "../../Misc/TermLine"
import "../TmuxSessionManager/TmuxSessionCard.qml"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
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

  Process {
    id: tmuxLs
    command: ["tmux", "list-sessions", "-F", "#{session_name}|#{session_windows}|#{session_created}|#{session_attached}"]
    running: true
    onRunningChanged: if (!running) running = true
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
        Item {
          id: card
          required property int index

          property string sessionName: sessionManager.sessions[card.index].name
          property int sessionWindows: sessionManager.sessions[card.index].windows
          property bool sessionAttached: sessionManager.sessions[card.index].attached

          width: column.width - 20
          height: 100

          property color altColor: Theme.altColor(index + 1)


          property var windows: []
          Process {
            command: ["tmux", "lsw", "-t", card.sessionName, "-F", "#{window_index}|#{window_name}|#{window_active}|#{window_panes}"]

            running: true
            onRunningChanged: if (!running) running = true
            stdout: StdioCollector {
              onStreamFinished: {
                card.windows = text.trim().split("\n").filter(l => l.length > 0).map(line => {
                  const parts = line.split("|")
                  return {
                    index: parseInt(parts[0]),
                    name: parts[1],
                    active: parts[2] === "1",
                    panels: parseInt(parts[3]),
                  }
                })
              }
            }
          }

          DragCardShape {
            id: cardShape
            anchors.fill: parent
            fillColor: Theme.foreground
            borderColor: Theme.border
            gripColor: Theme.dim
          }

          Item {
            width: cardShape.contentWidth - 10
            height: cardShape.contentHeight - 10 

            x: cardShape.x + 5 
            y: cardShape.y + 5

            Column {
              anchors.fill: parent

              Item {
                width: parent.width
                height: cardTitle.height

                Row {
                  anchors.left: parent.left
                  height: cardTitle.height
                  spacing: 5

                  Text {
                    id: cardTitle
                    text: qsTr(" " + "[" + card.index + "] " + ((parseInt(card.sessionName) == card.index)? "" : sessionManager.sessions[card.index].name))

                    font.family: "Bricolage Grotesque"

                    font.pointSize: 16
                    font.weight: Font.ExtraBold
                    color: Theme.colorGreen
                  }
                  Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("  " + card.sessionWindows)
                    color: Theme.dim
                    font.pointSize: 10

                    font.weight: Font.Bold
                  }
                }

                Rectangle {
                  visible: card.sessionAttached
                  anchors.right: parent.right
                  anchors.verticalCenter: parent.verticalCenter

                  width: attachedLabelText.height
                  height: attachedLabelText.height

                  color: card.altColor

                  radius: width

                  Text {
                    id: attachedLabelText
                    text: qsTr(" ")

                    anchors.centerIn: parent

                    font.pointSize: 12
                    font.weight: Font.Bold
                    color: Theme.foreground
                  }

                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                      Quickshell.execDetached(["sh", Quickshell.shellDir + "/assets/scripts/focus-tmux-hyprwin.sh", card.sessionName])
                    }
                  }
                }
              }

              Flow {
                width: parent.width
                height: 50
                spacing: 5

                Repeater {
                  model: card.windows.length

                  TermLine {
                    required property int index

                    property int windowIndex: card.windows[index].index
                    property string windowName: card.windows[index].name
                    property bool windowActive: card.windows[index].active
                    property int windowPanels: card.windows[index].panels

                    charHeight: 11

                    charHeightProportion: 0.86
                    bgWidthProportion: 0.953

                    segments: windowActive? [
                      { text: "", bg: Theme.foreground, fg: Theme.lightForeground },
                      { text: "" + windowIndex, bg: Theme.lightForeground, fg: Theme.text },
                      { text: "", bg: card.altColor, fg: Theme.lightForeground },
                      { text: " " + windowName + "  " + windowPanels, bg: card.altColor, fg: Theme.foreground },
                      { text: "", bg: Theme.foreground, fg: card.altColor},
                    ] : [
                      { text: "" + windowIndex + " " + windowName + "  " + windowPanels, bg: card.foreground, fg: Theme.dim },
                    ]
                  }
                }
              }
            }
          }
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

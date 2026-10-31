
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects

import Quickshell.Services.Greetd 
import QtQuick.VectorImage
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../../Theme"
import "../../../Misc/TextInput/"

Column {

  width: parent.width

  padding: 10
  spacing: 10

  leftPadding: 30
  rightPadding: 30


  Rectangle {
    id: userCard
    anchors.left: parent.left
    anchors.right: parent.right
    // anchors.margins: 12

    height: row.height
    radius: 12
    color: "transparent" // Theme.lightForeground

    property color highlightColor: Theme.altColorNoPurple(Math.floor(Math.random() * 3))

    Row {
      id: row
      spacing: 10
      padding: 10
      leftPadding: 20
      rightPadding: 20 

      Rectangle {
        width: 60
        height: 60
        radius:  11 // width / 2
        color: userCard.highlightColor

        Image {
          id: photo
          anchors.fill: parent
          anchors.margins: 2
          source: "/var/lib/AccountsService/icons/" + Greetd.user
          fillMode: Image.PreserveAspectCrop
          smooth: true
          mipmap: true
          visible: false
        }

        Rectangle {
          id: photoMask
          anchors.fill: photo
          radius: 10 // width / 2
          antialiasing: true
          visible: false
          layer.enabled: true
          layer.smooth: true
          layer.samples: 8
          layer.textureSize: Qt.size(width * 2, height * 2)
        }

        MultiEffect {
          anchors.fill: photo
          source: photo
          maskEnabled: true
          maskSource: photoMask
          maskThresholdMin: 0.5
          maskSpreadAtMin: 1.0
        }
      }

      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr(Greetd.user || "N/A")
        color: userCard.highlightColor
        font.pointSize: 16
        font.family: "Bricolage Grotesque"
        font.weight: Font.ExtraBold
      }
    }

    Item {
      anchors.right: parent.right
      anchors.rightMargin: 20
      anchors.verticalCenter: parent.verticalCenter
      width: 25
      height: 25

      VectorImage {
        id: logOutIcon
        source: "../../assets/icons/log-out.svg"
        preferredRendererType: VectorImage.CurveRenderer
        anchors.fill: parent
        visible: false
      }

      ColorOverlay {
        anchors.fill: logOutIcon
        source: logOutIcon
        color: Theme.dim
      }
    }
  }


  Rectangle { 
    anchors.left: parent.left
    anchors.right: parent.right

    //anchors.leftMargin: 15
    //anchors.rightMargin: 15



    height: 1
    color: Theme.border
  }

  RowLayout {
    width: parent.width - parent.leftPadding - parent.rightPadding

    Item {
      Layout.preferredWidth: 22
      Layout.preferredHeight: 22

      VectorImage {
        id: pwdIcon
        source: "../../assets/icons/key-round.svg"
        preferredRendererType: VectorImage.CurveRenderer
        anchors.fill: parent
      }

      ColorOverlay {
        anchors.fill: pwdIcon
        source: pwdIcon
        color: Theme.dim
      }
    }

    TextInput {
      id: passwordInput
      Layout.fillWidth: true
      placeholderText: "Password"
      echoMode: TextInput.Password
      passwordMaskDelay: 0
    }
  }

  function submit() {
    Greetd.respond(passwordInput.text)
  }
}

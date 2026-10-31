import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.VectorImage
import Qt5Compat.GraphicalEffects
import "../../Theme"
import "../../Misc/Button/"
import "../../ShellState/"
import "./LoginUserPage/"
import "./LoginAuthPage/"

import Quickshell.Services.Greetd 


Column {
  id: root

  anchors.centerIn: parent

  width: 450


  Rectangle {
    width: parent.width
    height: content.implicitHeight

    radius: 12

    color: Theme.foreground
    border.color: Theme.border
    border.width: 1

    Column {
      id: content

      width: parent.width

      Item {
        width: parent.width
        height: 35

        Row {

          anchors.fill: parent
          anchors.leftMargin: 12

          spacing: 8

          Row {

            leftPadding: 6
            rightPadding: 6

            spacing: 12

            anchors.verticalCenter: parent.verticalCenter

            Item {
              width: 15
              height: 15

              anchors.verticalCenter: parent.verticalCenter

              VectorImage {
                id: backIcon
                source: "../../assets/icons/arrow-left.svg"
                preferredRendererType: VectorImage.CurveRenderer
                anchors.fill: parent
              }

              ColorOverlay {
                anchors.fill: backIcon
                source: backIcon
                color: Theme.breadcumbColor
              }
            }

            Item {
              width: 15
              height: 15

              anchors.verticalCenter: parent.verticalCenter

              VectorImage {
                id: fowardIcon
                source: "../../assets/icons/arrow-right.svg"
                preferredRendererType: VectorImage.CurveRenderer
                anchors.fill: parent
              }

              ColorOverlay {
                anchors.fill: fowardIcon
                source: fowardIcon
                color: Theme.breadcumbColor
              }
            }
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("User")
            color:  Greetd.state == GreetdState.Inactive? Theme.fileHeaderTitleColor : Theme.breadcumbColor

            font.weight: Font.Medium

            leftPadding: 1
            rightPadding: 1
          }


          Text {
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("/")
            visible: Greetd.state == GreetdState.Authenticating

            font.weight: Font.Light
            color: Theme.breadcrumbSeparatorColor

            leftPadding: 1
            rightPadding: 1
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr(Greetd.user || "kito" )
            visible: Greetd.state == GreetdState.Authenticating

            color: Theme.fileHeaderTitleColor

            leftPadding: 1
            rightPadding: 1
          }
        }

        Rectangle {
          anchors.verticalCenter: parent.bottom
          height: 1
          width: parent.width
          color: Theme.border
        }
      }

      LoginUserPage {
        id: loginUserPage

        visible: Greetd.state == GreetdState.Inactive

        Component.onCompleted: {
          if (Greetd.state == GreetdState.Inactive && !ShellState.cache.lastGreeterUser && ShellState.cache.lastGreeterSession) {
            Greetd.createSession(ShellState.cache.lastGreeterUser)
          }
        }
      }


      LoginAuthPage {
        id: loginAuthPage
        visible: Greetd.state == GreetdState.Authenticating
      }

      Column {


        width: parent.width

        padding: 10
        topPadding: 0
        spacing: 10

        leftPadding: 30
        rightPadding: 30

        Rectangle { 
          anchors.left: parent.left
          anchors.right: parent.right

          anchors.leftMargin: 15
          anchors.rightMargin: 15



          height: 1
          color: Theme.border
        }

        Button {

          shadowMargin: 0
          backgroundColor: Theme.mainButtonColor
          anchors.right: parent.right
          anchors.margins: 30

          onClicked: {
            if (Greetd.state == GreetdState.Inactive) loginUserPage.submit()
            if (Greetd.state == GreetdState.Authenticating) loginAuthPage.submit()
          }

          Text {
            text: qsTr("Login")
            color: Theme.text
          }
        }
      }
    }
  }

  Connections {
    target: Greetd

    function onReadyToLaunch() {
      Greetd.launch(["gio", "launch", ShellState.selectedSessionPath])
    }
  }
}

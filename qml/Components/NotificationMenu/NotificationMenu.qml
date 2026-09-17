
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Services.Notifications 
import "../../Theme/"
import "../../Services/NotificationStatus/"
import "../../Misc/Button/"
import "../../Misc/TextInput/"

Column {


  spacing: 10 

  Text {
    text: qsTr("Notifications")
    font.pixelSize: 15
    font.family: "Bricolage Grotesque"
    font.weight: Font.ExtraBold
    color: Theme.text
    anchors.left: parent.left
    anchors.leftMargin: 16
  }



  Repeater {
    model: NotificationStatus.trackedNotifications

    Rectangle {
      id: notification
      required property Notification modelData

      width: parent.width
      height: notificationContent.height
      color: Theme.messageBackground // branco'
      radius: 6

      border.width: 1

      border.color: "#615142"


      Item {
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: 4
        anchors.rightMargin: 4

        width: 15
        height: 15


        Image {
          source: "../../assets/icons/trash.svg"
          anchors.fill: parent

          fillMode: Image.PreserveAspectFit

          ColorOverlay {
            anchors.fill: parent
            source: parent
            color: Theme.dim

          }
        }

        MouseArea {
          anchors.fill: parent

          cursorShape: Qt.PointingHandCursor
          onClicked: notification.modelData.dismiss()
        }

      }

      Column {

        id: notificationContent

        anchors.left: parent.left
        anchors.right: parent.right



        Row {

          anchors.left: parent.left
          anchors.right: parent.right

          padding: 5
          bottomPadding: 0
          Image {
            id: notificationAppIcon
            source: notification.modelData.appIcon

            fillMode: Image.PreserveAspectFit

            height: 20

            anchors.verticalCenter: parent.verticalCenter

          }
          Text {
            text: notification.modelData.appName.replace(/\b\w/g, c => c.toUpperCase()) 
            wrapMode: Text.WordWrap

            color: Theme.messageForeground

            font.pointSize: 10





          }
        }

        Row {

          anchors.left: parent.left
          anchors.right: parent.right

          padding: 5
          spacing: 5
          Image {
            id: notificationImage
            source: notification.modelData.image

            fillMode: Image.PreserveAspectFit

            height: 20

            anchors.verticalCenter: parent.verticalCenter

          }
          Text {
            text: notification.modelData.summary
            wrapMode: Text.WordWrap

            color: Theme.messageForeground

            font.bold: true
            font.pointSize: 9
            font.family: "Bricolage Grotesque"

            bottomPadding: 6


            width: parent.width - notificationImage.width

          }
        }

        Text {
          text: notification.modelData.body
          anchors.left: parent.left
          anchors.right: parent.right
          wrapMode: Text.WordWrap

          color: Theme.messageForeground

          padding: 5

        }

        Row {

          padding: 5

          Repeater {
            model: notification.modelData.actions


            Button {
              id: actionButton
              required property NotificationAction modelData
              required property int index

              property int actionAmount: notification.modelData.values.length


              shadowMargin: 0


              buttonWidth: actionButtonLabel.implicitWidth + 20


              radiusLeft: index == 0? 8 : 0
              radiusRight: index == actionAmount? 8 : 0

              onClicked: {
                modelData.invoke()
              }

              Row {
                id: actionButtonLabel
                anchors.centerIn: parent
                spacing: 4

                Image {
                  visible: notification.modelData.hasActionIcons
                  source: actionButton.modelData.identifier
                  height: 15
                  width: 15
                }

                Text {
                  text: actionButton.modelData.text
                  color: Theme.text
                }
              }
            }
          }
        }


        Row {
          visible: notification.modelData.hasInlineReply
          anchors.left: parent.left
          anchors.right: parent.right



          padding: 5 
          spacing: 5
          TextField {
            id: replyTextField
            implicitWidth: parent.width - sendReplyButton.width - parent.padding * 3
            placeholderText: notification.modelData.inlineReplyPlaceholder
          }

          Button {
            id: sendReplyButton
            shadowMargin: 0
            buttonWidth: buttonHeight

            onClicked: {
              notification.modelData.sendInlineReply(replyTextField.text)
            }

            Image {
              source: "../../assets/icons/send-horizontal.svg"
              width: 15
              height: 15

              ColorOverlay {
                anchors.fill: parent
                source: parent
                color: Theme.dim
              }
            }
          }
        }

      }
      Timer {
        interval: notification.modelData.expireTimeout > 0 ? notification.modelData.expireTimeout * 1000 : -1
        running: interval > 0
        onTriggered: notification.modelData.expire()
      }
    }
  }

}

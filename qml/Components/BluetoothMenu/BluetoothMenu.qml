pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Controls.Basic 
import Quickshell.Bluetooth 
import "../../Misc/Toggle/"
import "../../Misc/Button/"
import "../../Theme/"

Column {

  spacing: -5

  Item {
    width: 50
    height: 8
  }

  Item {
    width: parent.width
    implicitHeight: Math.max(bluetoothText.implicitHeight, bluetoothToggle.implicitHeight) + 15

    Text {
      id: bluetoothText
      text: qsTr("Bluetooth")
      font.pixelSize: 15
      font.family: "Bricolage Grotesque"
      font.weight: Font.ExtraBold
      color: Theme.text
      anchors.left: parent.left
      anchors.leftMargin: 16
    }

    Toggle {
      id: bluetoothToggle
      anchors.right: parent.right
      anchors.rightMargin: 10
      anchors.verticalCenter: bluetoothText.verticalCenter
      checked: Bluetooth.defaultAdapter.enabled
      onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
    }
  }


  Column {

    visible: Bluetooth.defaultAdapter.enabled
    anchors.left: parent.left
    anchors.right: parent.right

    spacing: 10

    Rectangle {
      id: quickSetting
      anchors.left: parent.left
      anchors.right: parent.right
      height: childrenRect.height
      radius: 12
      color: Theme.darkForeground

      Column {
        id: quickSettingsContent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20

        bottomPadding: 10
        spacing: 10

        Item {
          width: parent.width
          height: 1
        }

        Item {
          visible: deviceRepeater.count <= 0
          anchors.left: parent.left
          anchors.right: parent.right

          height: 50

          Text {
            anchors.centerIn: parent

            text: "No paired devices."
            color: Theme.dim
            font.pointSize: 14

            horizontalAlignment: Text.AlignHCenter
          }
        }

        Repeater {
          id: deviceRepeater
          model: Bluetooth.devices.values.filter(i => i.paired)

          Column {

            id: device
            required property int index
            required property BluetoothDevice modelData

            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 10

            Rectangle {
              visible: device.index > 0
              height: 1
              width: parent.width
              color: Theme.border
            }

            Item {
              height: childrenRect.height

              anchors.left: parent.left
              anchors.right: parent.right


              Row {
                anchors.left: parent.left
                spacing: 5
                Image {
                  source: Quickshell.iconPath(device.modelData.icon) 

                  width: 30
                  fillMode: Image.PreserveAspectFit

                  Component.onCompleted: {
                    console.log(Quickshell.iconPath(device.modelData.icon))
                  }
                }
                Column {
                  id: deviceInfo
                  Text {
                    text: qsTr(device.modelData.name)
                    color: Theme.text
                    font.family: "Bricolage Grotesque"
                    font.weight: Font.ExtraBold
                  }

                  Text {
                    text: qsTr(
                      BluetoothDeviceState.toString(device.modelData.state) + 
                      (device.modelData.batteryAvailable? " -    %" + Math.round(device.modelData.battery * 100) : "")
                    )

                    color: Theme.dim
                    font.pixelSize: 10
                  }
                }
              }
              Row {
                anchors.right: parent.right
                // anchors.rightMargin: -5
                anchors.verticalCenter: parent.verticalCenter
                ToolButton {
                  id: deviceOptions
                  anchors.verticalCenter: parent.verticalCenter
                  width: 24
                  height: 24
                  padding: 0           // remove o padding padrão

                  icon.source: "../../assets/icons/ellipsis-vertical.svg"
                  icon.color: Theme.dim
                  icon.width: 20
                  icon.height: 20

                  background: Item { }

                  onClicked: deviceOptionsMenu.open()

                  Menu {
                    id: deviceOptionsMenu
                    y: deviceOptions.height
                    x: deviceOptions.width - (width / 2)
                    width: 100
                    height: 25

                    MenuItem {
                      text: "Forget"
                      height: 25
                      onTriggered: device.modelData.forget()
                    }
                  }
                }
                Toggle {

                  anchors.verticalCenter: parent.verticalCenter
                  checked: device.modelData.connected
                  onClicked: device.modelData.connected = !device.modelData.connected

                }
              }
            }

          }
        }

      }
    }

    Item {
      id: pairables

      property bool open: false

      width: parent.width
      implicitHeight: pairablesLayout.implicitHeight

      onOpenChanged: {
        Bluetooth.defaultAdapter.discovering = open
      }

      Column {
        id: pairablesLayout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 5

        Text {
          text: qsTr((pairables.open ? "▾" : "▸") + " Pair")
          font.pixelSize: 13
          font.family: "Bricolage Grotesque"
          font.weight: Font.ExtraBold
          color: Theme.text
          anchors.left: parent.left
          anchors.leftMargin: 20

          MouseArea {
            anchors.fill: parent
            onClicked: pairables.open = !pairables.open
          }
        }

        Rectangle {
          visible: pairables.open
          anchors.left: parent.left
          anchors.leftMargin: 4
          anchors.right: parent.right
          implicitHeight: pairablesContent.implicitHeight + 20
          radius: 12
          color: Theme.darkForeground

          Column {
            id: pairablesContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            spacing: 10

            Item {
              height: 5
              width: 1
            }


            Item {
              visible: pairableRepeater.count <= 0
              anchors.left: parent.left
              anchors.right: parent.right

              height: 50

              Text {
                anchors.centerIn: parent

                text: "No device found."
                color: Theme.dim
                font.pointSize: 14

                horizontalAlignment: Text.AlignHCenter
              }
            }

            Repeater {
              id: pairableRepeater
              model: Bluetooth.devices.values.filter(i => !i.paired)

              Column {
                id: pairable
                required property int index
                required property BluetoothDevice modelData

                width: parent.width
                spacing: 10

                Rectangle {
                  visible: pairable.index > 0
                  height: 1
                  width: parent.width
                  color: Theme.border
                }

                Item {
                  width: parent.width
                  implicitHeight: 20

                  Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 5

                    Image {
                      source: Quickshell.iconPath(pairable.modelData.icon)
                      width: 20
                      fillMode: Image.PreserveAspectFit
                    }

                    Text {
                      id: pairableInfo
                      text: qsTr(pairable.modelData.name)
                      color: Theme.text
                      font.family: "Bricolage Grotesque"
                      font.weight: Font.ExtraBold
                      anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                      visible: pairable.modelData.pairing
                      text: qsTr("Pairing...")
                      color: Theme.dim
                      anchors.verticalCenter: parent.verticalCenter
                    }
                  }

                  Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Button {

                      buttonWidth: pairButtonLabel.height + 9

                      buttonHeight: buttonWidth

                      backgroundColor: pairable.modelData.pairing? Theme.dangerButtonColor : Theme.mainButtonColor

                      buttonInsetShadowSize: 1

                      onClicked: {
                        if (pairable.modelData.pairing) {
                          pairable.modelData.cancelPair()
                        }
                        else {
                          pairable.modelData.trusted = true
                          pairable.modelData.pair()
                        }
                      }


                      Text {
                        id: pairButtonLabel
                        text: pairable.modelData.pairing? qsTr("󰜺 ") : qsTr(" ")

                        anchors.centerIn: parent

                        font.pointSize: 8
                        font.weight: Font.Bold
                        color: Theme.text
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

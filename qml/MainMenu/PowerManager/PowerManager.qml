pragma ComponentBehavior: Bound

import QtQuick
import "../../Theme"
import "./PowerOption"

Rectangle {
  id: root

  implicitWidth: content.implicitWidth - 15
  implicitHeight: content.implicitHeight - 15

  property bool simple: false

  Row {
    id: content

    anchors.centerIn: parent
    spacing: -32

    property int optionSize: 50

    PowerOption {
      hasRadiusLeft: true
      label: "Reboot"
      //backgroundColor: Theme.foreground
      iconPath: "rotate-ccw.svg"
      backgroundColor: Theme.buttonColor
      buttonLightColor: Theme.colorLightYellow
      buttonWidth: content.optionSize
      buttonHeight: content.optionSize
      buttonRadius: 12
      command: "hyprshutdown --post-cmd 'systemctl reboot'"
    }

    PowerOption {
      label: "Shutdown"
      //backgroundColor: Theme.foreground
      iconPath: "power.svg"
      backgroundColor: Theme.buttonColor
      buttonLightColor: Theme.colorLightRed
      buttonWidth: content.optionSize
      buttonHeight: content.optionSize
      buttonRadius: 12
      command: "hyprshutdown --post-cmd 'systemctl poweroff'"

      hasRadiusRight: !root.simple
    }

    PowerOption {
      visible: !root.simple
      label: "Hibernate"
      //backgroundColor: Theme.foreground
      iconPath: "zzz.svg"
      backgroundColor: Theme.mainButtonColor
      buttonLightColor: Theme.colorLightBlue
      buttonWidth: content.optionSize
      buttonHeight: content.optionSize
      buttonRadius: 12
      command: "systemctl hibernate"
    }

    PowerOption {

      visible: !root.simple
      label: "Lock"
      //backgroundColor: Theme.foreground
      iconPath: "lock.svg"
      backgroundColor: Theme.buttonColor
      buttonLightColor: Theme.colorLightPurple
      buttonWidth: content.optionSize
      buttonHeight: content.optionSize
      buttonRadius: 12
      command: "hyprlock"
    }

    PowerOption {

      visible: !root.simple
      hasRadiusRight: true
      label: "Log out"
      //backgroundColor: Theme.foreground
      iconPath: "log-out.svg"
      backgroundColor: Theme.buttonColor
      buttonLightColor: Theme.colorLightGreen
      buttonWidth: content.optionSize
      buttonHeight: content.optionSize
      buttonRadius: 12
      command: "hyprctl dispatch 'hl.dsp.exit()'"
    }
  }
}

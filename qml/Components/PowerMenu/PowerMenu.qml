import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Services.SystemTray

import "../PowerMenu"
import "../../Theme"
import "./PowerMenuOption"

PanelWindow {
    id: modal

    color: "transparent"
    visible: PowerMenuState.isPowerMenuOpen || revealCircle.size > 1

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    Item {
        anchors.fill: parent

        property bool isOpen: PowerMenuState.isPowerMenuOpen

        onIsOpenChanged: {
            if (isOpen) {
                closeAnim.stop()
                cardCloseAnim.stop()
                clockCloseAnim.stop()

                revealCircle.size = 0
                cardTranslate.y = 40
                clockTranslate.y = -40
                card.opacity = 0
                clockText.opacity = 0

                openAnim.start()
            } else {
                openAnim.stop()
                cardOpenAnim.stop()
                clockOpenAnim.stop()

                cardCloseAnim.start()
                clockCloseAnim.start()
            }
        }

        Rectangle {
            id: revealCircle

            property real size: 0
            property real maxSize: Math.sqrt(Screen.width * Screen.width + Screen.height * Screen.height) * 2

            width: size
            height: size
            radius: size / 2

            x: -size / 2
            y: parent.height - size / 2

            color: Theme.background
            border.color: Theme.border

            NumberAnimation {
                id: openAnim

                target: revealCircle
                property: "size"
                to: revealCircle.maxSize
                duration: 500
                easing.type: Easing.OutCubic

                onStopped: {
                    if (PowerMenuState.isPowerMenuOpen) {
                        cardOpenAnim.start()
                        clockOpenAnim.start()
                    }
                }
            }

            NumberAnimation {
                id: closeAnim

                target: revealCircle
                property: "size"
                to: 0
                duration: 500
                easing.type: Easing.InCubic
            }
        }

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        Text {
            id: clockText

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 100

            text: Qt.formatDateTime(clock.date, "h'h'mm")

            color:  Theme.text //Theme.text
            font.pixelSize: 60
            opacity: 0

            transform: Translate {
                id: clockTranslate
                y: -40
            }

            NumberAnimation {
                id: clockOpenAnim

                target: clockTranslate
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutCubic

                onStarted: clockText.opacity = 1
            }

            NumberAnimation {
                id: clockCloseAnim

                target: clockTranslate
                property: "y"
                to: -40
                duration: 300
                easing.type: Easing.InCubic

                onStopped: {
                    clockText.opacity = 0
                    clockTranslate.y = -40
                }
            }
        }

        Rectangle {
            id: card

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            implicitWidth: content.implicitWidth  - 15
            implicitHeight: content.implicitHeight - 15

            radius: 12
            color: Theme.foreground
            border.color: Theme.border

            opacity: 0

            transform: Translate {
                id: cardTranslate
                y: 40
            }

            NumberAnimation {
                id: cardOpenAnim

                target: cardTranslate
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutCubic

                onStarted: card.opacity = 1
            }

            NumberAnimation {
                id: cardCloseAnim

                target: cardTranslate
                property: "y"
                to: 40
                duration: 300
                easing.type: Easing.InCubic

                onStopped: {
                    card.opacity = 0
                    cardTranslate.y = 40
                    closeAnim.start()
                }
            }

            Row {
                id: content

                anchors.centerIn: parent
                spacing: -32

                property int optionSize: 50

                PowerMenuOption {
                    hasRadiusLeft: true
                    label: "Reboot"
                    backgroundColor: Theme.foreground
                    iconPath: "rotate-ccw.svg"
                    buttonColor: Theme.buttonColor
                    buttonLightColor: Theme.colorLightYellow
                    buttonWidth: content.optionSize
                    buttonHeight: content.optionSize
                    buttonRadius: 12
                    command: "hyprshutdown --post-cmd 'systemctl reboot'"
                }

                PowerMenuOption {
                    label: "Shutdown"
                    backgroundColor: Theme.foreground
                    iconPath: "power.svg"
                    buttonColor: Theme.buttonColor
                    buttonLightColor: Theme.colorLightRed
                    buttonWidth: content.optionSize
                    buttonHeight: content.optionSize
                    buttonRadius: 12
                    command: "hyprshutdown --post-cmd 'systemctl poweroff'"
                }

                PowerMenuOption {
                    label: "Hibernate"
                    backgroundColor: Theme.foreground
                    iconPath: "zzz.svg"
                    buttonColor: Theme.mainButtonColor
                    buttonLightColor: Theme.colorLightBlue
                    buttonWidth: content.optionSize
                    buttonHeight: content.optionSize
                    buttonRadius: 12
                    command: "systemctl hibernate"
                }

                PowerMenuOption {
                    label: "Lock"
                    backgroundColor: Theme.foreground
                    iconPath: "lock.svg"
                    buttonColor: Theme.buttonColor
                    buttonLightColor: Theme.colorLightPurple
                    buttonWidth: content.optionSize
                    buttonHeight: content.optionSize
                    buttonRadius: 12
                    command: "hyprlock"
                }

                PowerMenuOption {
                    hasRadiusRight: true
                    label: "Log out"
                    backgroundColor: Theme.foreground
                    iconPath: "log-out.svg"
                    buttonColor: Theme.buttonColor
                    buttonLightColor: Theme.colorLightGreen
                    buttonWidth: content.optionSize
                    buttonHeight: content.optionSize
                    buttonRadius: 12
                    command: "hyprctl dispatch exit"
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            anchors.bottomMargin: 10

            implicitWidth: 64
            implicitHeight: 35

            radius: 12
            color: "transparent"

            PowerMenuToggle {
                anchors.centerIn: parent
            }
        }
    }
}

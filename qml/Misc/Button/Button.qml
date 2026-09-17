import QtQuick
import "../../Theme/"

Item {
    id: root
    property real buttonWidth: content.implicitWidth + 20
    property real buttonHeight: 32
    property real buttonInsetShadowSize: 2
    property real cornerRadius: 8
    property real radiusLeft: cornerRadius
    property real radiusRight: cornerRadius
    property real radiusTopLeft: radiusLeft
    property real radiusTopRight: radiusRight
    property real radiusBottomRight: radiusRight
    property real radiusBottomLeft: radiusLeft
    property color backgroundColor: Theme.buttonColor
    property real shadowMargin: 16
    default property alias content: content.data
    signal clicked()
    implicitWidth: buttonWidth + 2 * shadowMargin
    implicitHeight: buttonHeight + 2 * shadowMargin
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        id: box
        x: root.shadowMargin
        y: root.shadowMargin
        width: root.buttonWidth
        height: root.buttonHeight
        color: root.backgroundColor
        topLeftRadius: root.radiusTopLeft
        topRightRadius: root.radiusTopRight
        bottomRightRadius: root.radiusBottomRight
        bottomLeftRadius: root.radiusBottomLeft
    }

    ShaderEffect {
        anchors.fill: parent
        property real resolutionX: width
        property real resolutionY: height
        property real boxHalfWidth: root.buttonWidth / 2
        property real boxHalfHeight: root.buttonHeight / 2
        property real insetShadowSize: root.buttonInsetShadowSize
        property real pressed: mouseArea.pressed ? 1 : 0
        property real radiusTopLeft: root.radiusTopLeft
        property real radiusTopRight: root.radiusTopRight
        property real radiusBottomRight: root.radiusBottomRight
        property real radiusBottomLeft: root.radiusBottomLeft
        fragmentShader: "../../assets/shaders/button.frag.qsb"
    }

    Row {
        id: content
        anchors.centerIn: parent
        anchors.verticalCenterOffset: mouseArea.pressed ? 1 : -1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: box
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}

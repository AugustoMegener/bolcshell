import QtQuick


import Qt5Compat.GraphicalEffects

ShaderEffect {

  anchors.fill: parent
property real crtCurveAmntX: 2.0
property real crtCurveAmntY: 2.0

  fragmentShader: "../../assets/shaders/crt.frag.qsb"
}

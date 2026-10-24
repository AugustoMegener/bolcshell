import QtQuick
import QtQuick.VectorImage
import "../AudioStatus/AudioState"
import Qt5Compat.GraphicalEffects
import "../../Theme"

Item {
  width: 20
  height: 20

  VectorImage {
    id: icon
    source: "../../assets/icons/" + (AudioState.muted ? "volume-off" : "volume-2") + ".svg"

    anchors.fill: parent
    preferredRendererType: VectorImage.CurveRenderer

    antialiasing: true
    smooth: false 
  }

  ColorOverlay {
    anchors.fill: icon
    source: icon
    color: Theme.dim
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (AudioState.sink && AudioState.sink.audio) {
        AudioState.sink.audio.muted = !AudioState.sink.audio.muted
      }
    }
    onWheel: (wheel) => {
      AudioState.sink.audio.volume = Math.min(1, Math.max(AudioState.sink.audio.volume + (wheel.angleDelta.y > 0 ? 0.01 : -0.01)))
    }
  }
}

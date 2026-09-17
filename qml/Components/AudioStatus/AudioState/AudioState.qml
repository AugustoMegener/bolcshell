
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
    id: root

   readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property bool playing: peakMonitor.peak > 0.01

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    PwNodePeakMonitor {
        id: peakMonitor
        node: root.sink
        enabled: true
    }
}

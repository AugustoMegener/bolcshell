pragma Singleton
import Quickshell
import QtQuick

Singleton {
    enum State {
        Idle, MainModding
    }
    readonly property int state: DynamicIslandState.State.Idle
}

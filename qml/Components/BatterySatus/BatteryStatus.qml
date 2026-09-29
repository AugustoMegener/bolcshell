import QtQuick
import Quickshell
import "../../Theme"
import Qt5Compat.GraphicalEffects
import Quickshell.Services.UPower
import QtQuick.VectorImage

Row {
  visible: UPower.displayDevice.state === UPowerDeviceState.Charging
        || UPower.displayDevice.state === UPowerDeviceState.Discharging
        || UPower.displayDevice.state === UPowerDeviceState.Empty

  Item {
    id: battery
    width: 25
    height: 25
    anchors.verticalCenter: parent.verticalCenter

    property bool batteryLow: UPower.displayDevice.percentage <= 0.2

    Rectangle {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.topMargin: 9
      anchors.bottomMargin: 9
      anchors.leftMargin: 5
      anchors.rightMargin: 5
      width: (parent.width - 14) * UPower.displayDevice.percentage
      radius: 1
      color: battery.batteryLow ? Theme.activeAltColor : Theme.mixColors(Theme.mainButtonColor, Theme.activeAltColor, 0.33)
    }

    VectorImage {
      id: battery_icon_mask
      visible: battery.batteryLow || UPower.displayDevice.state == UPowerDeviceState.Charging
      source: (battery.batteryLow ? "../../assets/icons/battery-warning-mask.svg" : (UPower.displayDevice.state == UPowerDeviceState.Charging ? "../../assets/icons/battery-charging-mask.svg" : ""))
      anchors.fill: parent
      

      preferredRendererType: VectorImage.CurveRenderer
    }
    ColorOverlay {
      anchors.fill: battery_icon_mask
      source: battery_icon_mask
      color: Theme.background

      visible: battery.batteryLow || UPower.displayDevice.state == UPowerDeviceState.Charging
      enabled: battery.batteryLow || UPower.displayDevice.state == UPowerDeviceState.Charging
    }

    VectorImage {
      id: battery_icon
      source: "../../assets/icons/battery" + (battery.batteryLow ? "-warning" : (UPower.displayDevice.state == UPowerDeviceState.Charging ? "-charging" : "")) + ".svg"
      anchors.fill: parent
      preferredRendererType: VectorImage.CurveRenderer
      visible: false
    }
    ColorOverlay {
      anchors.fill: battery_icon
      source: battery_icon
      color: battery.batteryLow ? Theme.activeAltColor : Theme.dim
    }
  }

  Text {
    id: power_time
    anchors.verticalCenter: parent.verticalCenter
    leftPadding: 5

    text: {
      var isCharging = UPower.displayDevice.state == UPowerDeviceState.Charging
      var time = isCharging? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty
      var hours = Math.floor(time / 3600)
      var minutes = Math.floor((time % 3600) / 60) 

      return (hours > 0? hours + "h " : "") + (minutes > 0 ?  (minutes + "m ") : "") + (isCharging? " " : " ")
    }
    color: Theme.dim
    font.pixelSize: 14

  }
}

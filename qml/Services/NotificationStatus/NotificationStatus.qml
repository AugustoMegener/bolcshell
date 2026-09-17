pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias trackedNotifications: server.trackedNotifications

    onTrackedNotificationsChanged: {
      console.log("merda: " + trackedNotifications.list.lenght)
    }

    NotificationServer {
        id: server
    inlineReplySupported: true
    bodyImagesSupported: true
    bodyMarkupSupported: true

    actionsSupported: true
    bodyHyperlinksSupported: true
    actionIconsSupported: true

        onNotification: (notification) => {
            notification.tracked = true
        }
    }
}

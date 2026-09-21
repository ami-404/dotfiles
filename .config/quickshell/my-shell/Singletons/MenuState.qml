pragma Singleton
import QtQuick

QtObject {

    property string activePanel: "none"

    function togglePanel(panelName) {
        if (activePanel === panelName) {
            activePanel = "none";
        } else {
            activePanel = panelName;
        }
    }

    property bool wifiMenuOpen: false
    property bool notificationCenterOpen: false 
    property bool notificationPresent: false
}

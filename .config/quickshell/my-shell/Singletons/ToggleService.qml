pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland


Singleton {
    id: root
    property bool wifiEnabled: true
    property bool inhibitIdle: false

    function chngIdleState() {
        inhibitIdle = !inhibitIdle
    }

    function toggleWifi() {
            // const cmd = wifiEnabled ? "off" : "on";
            // enableWifiProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

 // 2. Define the process controller
    Process {
        id: wifiScanProcess
    }

    // 3. Your function executing the command
    function scanWifi() {
        // Runs 'nmcli device wifi rescan' through the system shell
        wifiScanProcess.exec(["sh", "-c", "nmcli device wifi rescan"])
    }

}

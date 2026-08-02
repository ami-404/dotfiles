pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property bool wifiEnabled: true

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

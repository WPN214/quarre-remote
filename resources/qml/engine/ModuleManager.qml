import QtQuick 2.0
import WPN114.Network 1.1 as Network
import Quarre 1.0

Item
{
    function fmt(str) {
        return "file://"+system.downloadPath()+"/modules/"+str;
    }

    Network.Client
    {
        id: download_client
        zeroConfHost: "quarre-modules"

        onDisconnected:
            console.log("DISCONNECTED FROM HOST");

        //onConnected: requestHttp("/modules")
    }
}

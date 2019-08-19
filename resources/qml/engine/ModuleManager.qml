import QtQuick 2.0
import WPN114.Network 1.0 as WPN114
import Quarre 1.0

Item
{
    function fmt(str)
    {
        return "file://"+system.downloadPath()+"/modules/"+str;
    }

    WPN114.OSCQueryClient
    {
        id: download_client
        zeroConfHost: "quarre-modules"

        onDisconnected: console.log("DISCONNECTED FROM HOST");

        //onConnected: requestHttp("/modules")
    }
}

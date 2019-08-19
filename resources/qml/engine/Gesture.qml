import QtQuick 2.0
import WPN114.Network 1.1 as Network

Item
{
    id: root

    property bool
    available: false

    property bool
    active: false

    property string
    name

    property alias
    trigger: trigger

    function check_availability()
    {
        var gestures = sensor_gesture.availableGestures;
        var index = gestures.indexOf("QtSensors." + name);
        available = index >= 0;
    }

    Network.Node on active { path: "/gestures/"+root.name+"/active" }
    Network.Node on available { path: "/gestures/"+root.name+"/available" }

    Network.Node
    {
        id: trigger
        path: "/gestures/"+root.name+"/trigger"
        type: Network.Type.Impulse
    }
}

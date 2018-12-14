import QtQuick 2.0
import WPN114.Network 1.0 as WPN114

Item
{
    id: root
    property bool available:    false
    property bool active:       false
    property string name:       ""

    property alias trigger: trigger

    function check_availability()
    {
        var gestures    = sensor_gesture.availableGestures;
        var index       = gestures.indexOf("QtSensors." + name);

        if ( index >= 0 ) available = true;
    }

    WPN114.Node on active { path: "/gestures/"+root.name+"/active" }
    WPN114.Node on available { path: "/gestures/"+root.name+"/available" }

    WPN114.Node
    {
        id: trigger
        path: "/gestures/"+root.name+"/trigger"
        type: WPN114.Type.Impulse
    }
}

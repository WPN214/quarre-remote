import QtQuick 2.0
import QtSensors 5.3

Item
{
    property bool connected: false
    property var gestures: [ "whip", "cover", "turnover", "shake" ]
    property alias backend: sensor_gesture

    SensorGesture { id: sensor_gesture; onDetected: { system.vibrate(100) } }
    Repeater { id: gesture_array; model: gestures; Gesture { name: modelData } }

    Component.onCompleted:
    {
        for ( var i = 0; i < gestures.length; ++ i )
            gesture_array.itemAt(i).check_availability();
    }    
}

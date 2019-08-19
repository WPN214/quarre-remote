import QtQuick 2.0
import QtSensors 5.3
import Quarre 1.0 as Quarre
import WPN114.Network 1.0 as WPN114

Rectangle
{
    property alias accelerometers: sensors_accelerometers
    property alias rotation: sensors_rotation
    property alias microphone: sensors_microphone
    property alias proximity: sensors_proximity

    function stop()
    {
        sensors_microphone.active       = false;
        sensors_accelerometers.active   = false;
        sensors_rotation.active         = false;
        sensors_proximity.active        = false;
        polling_timer.running           = false;
    }

    Timer //---------------------------------------------------------------------- POLLING_TIMER
    {
        id:         polling_timer
        interval:   50
        repeat:     true

        onTriggered:
        {
            if ( sensors_microphone.active ) microphone_rms = sensors_microphone.rms
            if ( sensors_accelerometers.active )
                accelerometers_xyz = Qt.vector3d (
                            sensors_accelerometers.reading.x, sensors_accelerometers.reading.y,
                            sensors_accelerometers.reading.z )

            if ( sensors_rotation.active )
                rotation_xyz = Qt.vector3d (
                            sensors_rotation.reading.x, sensors_rotation.reading.y,
                            sensors_rotation.reading.z )

            if ( sensors_proximity.active ) proximity_close = sensors_proximity.reading.near
        }
    }

    Quarre.Audio //-------------------------------------------------------------- MICROPHONE
    {
        id:         sensors_microphone
        active:     false

        WPN114.Node on active { path: "/sensors/microphone/active" }

        onActiveChanged:
        {
            if ( active && !polling_timer.running ) polling_timer.running = true;
            else if ( !active && !accelerometers.active && !rotation.active && !proximity.active )
                polling_timer.running = false;
        }
    }    

    property real microphone_rms: 0.0
    WPN114.Node on microphone_rms { path: "/sensors/microphone/data/rms" }

    Accelerometer //---------------------------------------------------------------- ACCELEROMETERS
    {
        id:         sensors_accelerometers
        active:     false

        WPN114.Node on active { path: "/sensors/accelerometers/active" }                        

        onActiveChanged:
        {
            if ( active && !polling_timer.running ) polling_timer.running = true;
            else if ( !active && !microphone.active && !rotation.active && !proximity.active )
                polling_timer.running = false;
        }

        Component.onCompleted: accelerometers_available.value = connectedToBackend
    }

    WPN114.Node
    {
        id: accelerometers_available;
        path: "/sensors/accelerometers/available"
        type: WPN114.Type.Bool
    }

    property real accelerometers_x: 0.0
    property real accelerometers_y: 0.0
    property real accelerometers_z: 0.0
    property vector3d accelerometers_xyz: Qt.vector3d(0.0,0.0,0.0)

    WPN114.Node on accelerometers_x { path: "/sensors/accelerometers/data/x" }
    WPN114.Node on accelerometers_y { path: "/sensors/accelerometers/data/y" }
    WPN114.Node on accelerometers_z { path: "/sensors/accelerometers/data/z" }
    WPN114.Node on accelerometers_xyz { path: "/sensors/accelerometers/data/xyz" }

    RotationSensor //---------------------------------------------------------------- ROTATION
    {
        id:         sensors_rotation
        active:     false

        WPN114.Node on active { path: "/sensors/rotation/active" }

        onActiveChanged:
        {
            if ( active && !polling_timer.running ) polling_timer.running = true;
            else if ( !active && !accelerometers.active && !microphone.active && !proximity.active )
                polling_timer.running = false;
        }

        Component.onCompleted: rotation_available.value = connectedToBackend
    }

    WPN114.Node
    {
        id: rotation_available
        type: WPN114.Type.Bool
        path: "/sensors/rotation/available"
    }

    property real rotation_x: 0.0
    property real rotation_y: 0.0
    property real rotation_z: 0.0
    property vector3d rotation_xyz: Qt.vector3d(0.0,0.0,0.0)

    WPN114.Node on rotation_x { path: "/sensors/rotation/x/data" }
    WPN114.Node on rotation_y { path: "/sensors/rotation/y/data" }
    WPN114.Node on rotation_z { path: "/sensors/rotation/z/data" }
    WPN114.Node on rotation_xyz { path: "/sensors/rotation/xyz/data" }

    ProximitySensor //---------------------------------------------------------------- PROXIMITY
    {
        id:         sensors_proximity
        active:     false

        WPN114.Node on active { path: "/sensors/proximity/active" }

        onActiveChanged:
        {
            if ( active && !polling_timer.running ) polling_timer.running = true;
            else if ( !active && !accelerometers.active && !rotation.active && !microphone.active )
                polling_timer.running = false;
        }

        Component.onCompleted: proximity_available.value = connectedToBackend
    }

    WPN114.Node
    {
        id: proximity_available;
        type: WPN114.Type.Bool;
        path: "/sensors/proximity/available"
    }

    property bool proximity_close: false
    WPN114.Node on proximity_close { path: "/sensors/proximity/close/data" }
}

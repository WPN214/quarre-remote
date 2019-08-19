import QtQuick 2.0
import WPN114.Network 1.0 as WPN114

Rectangle
{
    id: root
    property alias  timer_label: header_timer_label
    property alias  timer:       header_timer
    property alias  scenario:    header_scenario_label
    property alias  scene:       header_scene_label
    property int    count:       0

    WPN114.Node
    {
        path: "/scenario/reset"
        type: WPN114.Type.Impulse
        onValueReceived: root.count = 0
    }

    //-------------------------------------------------------------------------------------------------------
    states: [

        State
        {
            name: "FULL_VIEW"

            PropertyChanges
            {
                target: header_scenario_label
                height: header_scenario_label.font.pixelSize
                anchors.fill: undefined
                horizontalAlignment: Text.AlignHCenter
                anchors.leftMargin: 0
            }

            AnchorChanges
            {
                target: header_scenario_label
                anchors.bottom: header_scene_label.top
            }

            PropertyChanges
            {
                target: header_scene_label
                height: header_scene_label.font.pixelSize
                anchors.fill: undefined
                horizontalAlignment: Text.AlignHCenter
                anchors.rightMargin: 0
            }

            AnchorChanges
            {
                target: header_scene_label
                anchors.verticalCenter: header_scene_label.parent.verticalCenter
            }

            PropertyChanges
            {
                target: header_timer_label
                height: header_timer_label.font.pixelSize
                anchors.fill: undefined
            }

            AnchorChanges
            {
                target: header_timer_label
                anchors.top: header_scene_label.bottom
            }
        },

        State
        {
            name: "REDUCED_VIEW"
        }

    ]

    //-------------------------------------------------------------------------------------------------------

    function int_to_time(value)
    {
        var min = Math.floor(value/60), sec = value % 60;
        var min_str, sec_str;

        if      ( min < 10 )
                min_str = "0" + min.toString();
        else    min_str = min.toString();

        if      ( sec < 10 )
                sec_str = "0" + sec.toString();
        else    sec_str = sec.toString();

        return min_str + ":" + sec_str;
    }

    Timer //------------------------------------------------------------ TIMER
    {
        id: header_timer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            parent.count += 1;
            header_timer_label.text = parent.int_to_time(parent.count);
        }

        WPN114.Node on running { path: "/scenario/running" }
    }

    Text //------------------------------------------------------------ SCENARIO_LABEL
    {
        id:     header_scenario_label
        text:   "quarrè"
        color:  "#ffffff"

        verticalAlignment:      Text.AlignVCenter
        horizontalAlignment:    Text.AlignLeft
        anchors.fill:           parent
        anchors.leftMargin:     parent.width * 0.05

        textFormat:         Text.PlainText
        font.pointSize:     14 * root.fontRatio
        font.family:        font_lato_light.name

        WPN114.Node on text { path: "/scenario/name" }
    }

    Text //----------------------------------------------------------- TIMER_LABEL
    {
        id: header_timer_label
        text: "00:00"
        color: "#ffffff"

        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.PlainText
        font.pointSize: 14 * root.fontRatio
        font.family: font_lato_light.name
    }

    Text //----------------------------------------------------------- CURRENT_SCENE_NAME
    {
        id: header_scene_label
        text: "connecting"
        color: "#ffffff"

        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.fill: parent
        anchors.rightMargin: parent.width *0.05

        font.pointSize: 14 * root.fontRatio
        font.family: font_lato_light.name

        WPN114.Node on text { path: "/scenario/scene/name" }
    }

    Rectangle //---------------------------------------------------- CIRCLE
    {
        id:         header_circle

        width:      parent.width*0.4
        height:     width
        radius:     width/2
        color:      "#80000000"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        SequentialAnimation //-------------------------------------- CIRCLE_ANIMATIONS
        {
            running: true
            loops: Animation.Infinite

            ParallelAnimation
            {
                NumberAnimation
                {
                    target: header_circle
                    property: "width"
                    easing.type: Easing.InOutSine
                    to: header_circle.parent.width * 0.35
                    duration: 2000
                }

                NumberAnimation
                {
                    target: header_circle
                    property: "opacity"
                    to: 0.1
                    easing.type: Easing.InOutSine
                    duration: 2000
                }
            }

            ParallelAnimation
            {
                NumberAnimation
                {
                    target: header_circle
                    property: "width"
                    easing.type: Easing.InOutSine
                    to: header_circle.parent.width * 0.4
                    duration: 2000
                }

                NumberAnimation
                {
                    target: header_circle
                    property: "opacity"
                    to: 1.0
                    easing.type: Easing.InOutSine
                    duration: 2000
                }
            }
        }
    }

}

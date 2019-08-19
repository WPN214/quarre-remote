import QtQuick 2.0
import WPN114.Network 1.0 as WPN114

Rectangle
{
    property int    count:          0
    property alias  timer:          current_interaction_timer
    property alias  title:          current_interaction_title.text
    property alias  description:    current_interaction_description.text
    property alias  countdown:      current_interaction_countdown_label.text

    WPN114.Node on count { path: "/interactions/current/countdown" }

    states: [

        State //--------------------------------------------------- STATE_FULL_VIEW
        {
            name:           "FULL_VIEW"
            PropertyChanges
            {
                target:     current_interaction_circle
                width:      current.width * 0.38
                height:     current_interaction_circle.width
                radius:     current_interaction_circle.width/2
                y:          next.width * 0.0125
            }

            PropertyChanges //------------------------------ current_interaction_title
            {
                target: current_interaction_title
                y: current.width * 0.35
            }

            PropertyChanges //------------------------------ current_interaction_description
            {
                target: current_interaction_description
                y: current.width * 0.42
            }
        },

        State //--------------------------------------------------- STATE_REDUCED_VIEW
        {
            name: "REDUCED_VIEW"

            PropertyChanges
            {
                target: title_background
                y: current.width * 0.25
            }

            PropertyChanges
            {
                target: current_interaction_title
                y: current.width * 0.25
            }

            PropertyChanges
            {
                target: current_interaction_countdown_label
                font.pointSize: 45 * root.fontRatio
            }

            PropertyChanges
            {
                target: current_interaction_description
                y: current.width * 0.32
            }

            PropertyChanges
            {
                target: current_interaction_circle
                width: parent.width*0.33
                height: parent.width*0.33
                radius: width/2
            }
        }
    ]

    Timer //------------------------------------------------------------- TIMER
    {
        id:         current_interaction_timer
        interval:   1000
        running:    false
        repeat:     true

        onRunningChanged: title_xfade.running = current_interaction_timer.running;

        onTriggered:
        {
            if  ( parent.count == -1 )
                current_interaction_countdown_label.text = "inf";

            else if ( parent.count == 0 )
                      running = false
            else
            {
                parent.count -= 1;
                current_interaction_countdown_label.text = parent.count;
            }
        }
    }

    SequentialAnimation // ---------------------------------------------------- COUNTDOWN_ANIMATION
    {

        id:         title_xfade
        loops:      Animation.Infinite

        NumberAnimation
        {
            target:     current_interaction_countdown_label

            property:   "opacity"
            from:       1.0
            to:         0.1
            duration:   1000
        }

        NumberAnimation
        {
            target:     current_interaction_countdown_label

            property:   "opacity"
            from:       0.1
            to:         1.0
            duration:   1000
        }
    }

    Rectangle //----------------------------------------------------------- BACKGROUND
    {
        id:             background_color

        color:          "#670909"
        opacity:        0.3
        anchors.fill:   parent
    }

    Rectangle //----------------------------------------------------------- CIRCLE
    {
        id:         current_interaction_circle

        width:      parent.width*0.4
        height:     width
        radius:     width/2
        x:          (parent.width*0.5)-radius
        y:          -(radius/4)
        color:      "#80000000"

        MouseArea
        {
            anchors.fill: parent
            onClicked: current_interaction_timer.running = true;
        }

        Text
        {
            // the countdown itself
            id:         current_interaction_countdown_label

            text:       "0"
            color:      "#ffffff"

            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 55 * root.fontRatio
            textFormat: Text.PlainText
            font.family: font_lato_light.name
        }
    }

    Rectangle //------------------------------------------------------------- INFO_RECT_BG
    {
        id:         title_background

        color:      "black"
        opacity:    0.35
        width:      parent.width
        height:     parent.height *0.5
        y:          current.width * 0.35
    }

    Text //---------------------------------------------------------------- CURRENT_TITLE
    {
        id:         current_interaction_title

        text:       "trigger interaction"
        color:      "#ffffff"
        width:      parent.width
        height:     parent.height * 0.2
        y:          parent.height * 0.55

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 22 * root.fontRatio
        textFormat: Text.PlainText
        font.family: font_lato_light.name
    }

    Text //---------------------------------------------------------------- CURRENT_DESCRIPTION
    {
        id:         current_interaction_description

        y:          current_interaction_title.height + current_interaction_title.y
        color:      "#ffffff"
        text:       "no description"
        height:     parent.height * 0.3
        width:      parent.width * 0.9

        anchors.horizontalCenter: parent.horizontalCenter

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 14 * root.fontRatio
        textFormat: Text.PlainText
        wrapMode: Text.WordWrap
        font.family: font_lato_light.name
        antialiasing: true
    }
}

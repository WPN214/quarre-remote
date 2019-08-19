import QtQuick 2.0
import WPN114.Network 1.0 as WPN114

Rectangle
{
    // SECOND UPPER VIEW SECTION
    // used to display next interactions
    // it is composed of 3 elements: the 'NEXT' label
    // the label of the next interaction to come
    property int count: 0
    property alias timer: next_interaction_timer
    property alias title: next_interaction_title.text
    property alias description: next_interaction_description.text
    property alias countdown: next_interaction_countdown_label.text

    WPN114.Node on count { path: "/interactions/next/countdown" }

    states: [

        State //--------------------------------------------------------------- FULL_VIEW_STATE
        {
            name: "FULL_VIEW"

            PropertyChanges
            {
                target:     next_interaction_label
                text:       "PROCHAINE INTERACTION"

                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                height: next.height * 0.15

                font.pointSize: 25 * root.fontRatio
                y: next_interaction_label.parent.height * 0.1
                x: 0
            }

            PropertyChanges
            {
                target:     next_interaction_circle

                height:     next.height * 0.2
                width:      height
                radius:     height/2
                x:          0
            }

            AnchorChanges
            {
                target:     next_interaction_circle

                anchors.horizontalCenter: next.horizontalCenter
                anchors.top: next_interaction_label.bottom
                anchors.verticalCenter: undefined
            }

            PropertyChanges
            {
                target:     next_interaction_title

                font.pointSize: 20 * fontRatio
                anchors.topMargin: next.height * 0.1
            }

            AnchorChanges
            {
                target:     next_interaction_title

                anchors.top: next_interaction_circle.bottom
                anchors.verticalCenter: undefined
            }

            PropertyChanges
            {
                target:     next_interaction_description
                visible:    true
            }
        },

        State //--------------------------------------------------------------- REDUCED_VIEW_STATE
        {
            name: "REDUCED_VIEW"

            PropertyChanges
            {
                target:     next_interaction_label
                text:       "NEXT"

                font.pointSize: 20 * root.fontRatio
                verticalAlignment: Text.AlignVCenter
                x: next_interaction_label.width * 0.04
            }

            PropertyChanges
            {
                target:     next_interaction_title

                width:      next_interaction_title.parent.width * 0.47
                height:     next_interaction_title.parent.height
                x:          next_interaction_title.width*0.55

                font.pointSize: 16 * root.fontRatio
            }

            AnchorChanges
            {
                target:     next_interaction_title

                anchors.top:        next_interaction_title.parent.top
                anchors.bottom:     next_interaction_title.parent.bottom
                anchors.left:       next_interaction_title.parent.left
                anchors.right:      next_interaction_title.parent.right
            }

            PropertyChanges
            {
                target:     next_interaction_description
                visible:    false
            }

            PropertyChanges
            {
                target:     next_interaction_circle

                width: next_interaction_circle.parent.height * 0.8
                height: next_interaction_circle.parent.height * 0.8
                radius: next_interaction_circle.width/2
                x: next_interaction_circle.parent.width * 0.8
            }

            AnchorChanges
            {
                target:     next_interaction_circle

                anchors.verticalCenter: next_interaction_circle.parent.verticalCenter
            }
        }
    ]

    Timer //---------------------------------------------------------------------- TIMER
    {
        id:             next_interaction_timer

        interval:       1000
        running:        false
        repeat:         true

        onRunningChanged: title_xfade.running = next_interaction_timer.running;

        onTriggered:
        {
            if ( parent.count == -1)
                next_interaction_countdown_label.text = "inf";

            else if ( parent.count == 0 )
                running = false;

            else
            {
                parent.count -= 1;
                next_interaction_countdown_label.text = parent.count;
            }
        }
    }

    SequentialAnimation // ---------------------------------------------------- COUNTDOWN_ANIMATION
    {
        id:     title_xfade
        loops:  Animation.Infinite

        NumberAnimation
        {
            target: next_interaction_countdown_label
            property: "opacity"
            from: 1.0
            to: 0.1
            duration: 1000
        }

        NumberAnimation
        {
            target: next_interaction_countdown_label
            property: "opacity"
            from: 0.1
            to: 1.0
            duration: 1000
        }
    }

    Rectangle //----------------------------------------------------------------- BACKGROUND
    {
        anchors.fill:   parent
        color:          "#314f4d"
        opacity:        0.2
    }

    Text //---------------------------------------------------------------------- NEXT_LABEL
    {
        id: next_interaction_label
        text: "NEXT"
        color: "#ffffff"
        width: parent.width
        height: parent.height
        x: width*0.04
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 20 * root.fontRatio
        font.bold: true
        textFormat: Text.PlainText
    }

    Text  //---------------------------------------------------------------------- TITLE
    {
        id:         next_interaction_title

        text:       ""
        color:      "#ffffff"
        width:      parent.width * 0.47
        height:     parent.height


        anchors.fill: parent
        x: width*0.55
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: font_lato_light.name
        antialiasing: true
        font.pointSize: 16 * root.fontRatio
        font.bold:  false
        textFormat: Text.PlainText
        wrapMode:   Text.WordWrap
    }

    Text  //---------------------------------------------------------------------- DESCRIPTION
    {
        id:         next_interaction_description

        text:       ""
        color:      "#ffffff"
        width:      parent.width *0.7
        height:     parent.height*0.5

        y:          parent.height*0.49

        textFormat:             Text.PlainText
        wrapMode:               Text.WordWrap
        verticalAlignment:      Text.AlignVCenter
        horizontalAlignment:    Text.AlignHCenter

        anchors.horizontalCenter: parent.horizontalCenter

        font.family: font_lato_light.name
        font.pointSize: 14 * root.fontRatio

        antialiasing: true

    }

    Rectangle //---------------------------------------------------------------------- CIRCLE
    {
        id:         next_interaction_circle

        width:      parent.height * 0.8
        height:     parent.height * 0.8
        radius:     width/2

        color:      "#b3ffffff"
        x:          parent.width * 0.8

        anchors.verticalCenter: parent.verticalCenter

        Text //---------------------------------------------------------------------- COUNTDOWN_LABEL
        {
            id:     next_interaction_countdown_label

            anchors.fill: parent
            text: parent.parent.count
            color: "#000000"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 30 * root.fontRatio
            textFormat: Text.PlainText
        }
    }
}

import QtQuick 2.0

Rectangle
{
    color: "transparent"
    anchors.fill: parent

    Text //---------------------------------------------------------------------- LOGO
    {
        id:         quarre_log
        width:      parent.width
        height:     parent.height
        y:          parent.height*0.25
        color:      "#ffffff"
        text:       "quarrè"

        horizontalAlignment: Text.AlignHCenter        
        font.family: font_lato_light.name
        font.pointSize: 50 * root.fontRatio
        textFormat: Text.PlainText
        antialiasing: true
    }

    SequentialAnimation // ---------------------------------------------------- COUNTDOWN_ANIMATION
    {
        id:     title_xfade
        loops:  Animation.Infinite
        running: true

        NumberAnimation
        {
            target: quarre_log
            property: "opacity"
            from: 1.0
            to: 0.1
            duration: 5000
        }

        NumberAnimation
        {
            target: quarre_log
            property: "opacity"
            from: 0.1
            to: 1.0
            duration: 5000
        }
    }
}

import QtQuick 2.0

Rectangle
{
    color: "transparent"

    Text
    {
        id:     quarre_idle_text
        color:  "#ffffff"
        text:   "veuillez patienter \n jusqu'à la \n prochaine interaction"

        width:  parent.width
        height: parent.height

        horizontalAlignment:    Text.AlignHCenter
        verticalAlignment:      Text.AlignVCenter

        font.family:    font_lato_light.name
        font.pointSize: root.fontRatio * 30
        textFormat:     Text.PlainText
        antialiasing:   true
        wrapMode:       Text.WordWrap
    }

    SequentialAnimation // ---------------------------------------------------- COUNTDOWN_ANIMATION
    {
        id:     title_xfade
        loops:  Animation.Infinite
        running: true

        NumberAnimation
        {
            target: quarre_idle_text
            property: "opacity"
            from: 1.0
            to: 0.1
            duration: 2500
        }

        NumberAnimation
        {
            target: quarre_idle_text
            property: "opacity"
            from: 0.1
            to: 1.0
            duration: 2500
        }
    }
}

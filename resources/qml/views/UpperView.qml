import QtQuick 2.0

Rectangle {
    // UPPER VIEW
    // consists in 3 separate sections:
    // 1- the header, which is about 1/10th maybe of the upper view
    // 2- the next_interaction section, maybe 3/10th of the upper view
    // 3- the current_interaction section, 6/10th of the upper_view
    // note that: the different sections should appear and disappear whenever
    // they're useful or not, or need to draw attention from the user

    property alias next:        quarre_next_section
    property alias header:      quarre_header
    property alias current:     quarre_current_section

    HeaderView //------------------------------------ HEADER_VIEW
    {
        id:         quarre_header
        width:      parent.width
        height:     parent.height*0.1
        color:      "transparent"
    }

    NextInteractionView //-------------------------------- NEXT_INTERACTION_VIEW
    {
        id:         quarre_next_section
        width:      parent.width
        height:     parent.height*0.25
        y:          quarre_header.height
        color:      "transparent"
    }

    CurrentInteractionView  //---------------------------- CURRENT_INTERACTION_VIEW
    {
        id:         quarre_current_section
        width:      parent.width
        height:     parent.height*0.65
        y:          parent.height*0.35
        color:      "transparent"
    }
}

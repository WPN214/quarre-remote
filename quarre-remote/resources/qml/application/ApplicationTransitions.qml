import QtQuick 2.0

Item {

    transitions: [

        Transition
        {
            from: "DISCONNECTED"; to: "IDLE";
            reversible: true

            ParallelAnimation
            {
                NumberAnimation
                {
                    target: upper_view
                    property: "height"
                    duration: 1000
                }

                NumberAnimation
                {
                    target: upper_view.header
                    property: "height"
                    duration: 1000
                }

                NumberAnimation
                {
                    target: lower_view
                    property: "y"
                    duration: 1000
                }
            }

        },

        Transition // -------------------------------------------------- IDLE_TO_INCOMING
        {
            from: "IDLE"
            to: "INCOMING_INTERACTION"

            reversible: true

            SequentialAnimation
            {
                NumberAnimation
                {
                    target: upper_view.header
                    property: "height"
                    duration: 250
                    //easing.type: Easing.InElastic
                }

                NumberAnimation
                {
                    target: upper_view.next
                    property: "x"
                    duration: 250
                    //easing.type: Easing.OutBounce
                }

                NumberAnimation
                {
                    target: upper_view.next
                    property: "height"
                    duration: 250
                }
            }
        },

        Transition // -------------------------------------------------- INCOMING_TO_ACTIVE
        {
            from: "INCOMING_INTERACTION"
            to: "ACTIVE_INTERACTION"

            reversible: true

            ParallelAnimation
            {
                NumberAnimation
                {
                    target: upper_view.next
                    property: "x"
                    duration: 500
                }

                NumberAnimation
                {
                    target: upper_view.next
                    property: "height"
                    duration: 500
                }

                NumberAnimation
                {
                    target: upper_view.current
                    property: "x"
                    duration: 500
                }
            }
        },

        Transition // -------------------------------------------------- ACTIVE_TO_IDLE
        {
            from: "ACTIVE_INTERACTION"
            to: "IDLE"

            ParallelAnimation
            {
                NumberAnimation
                {
                    target: upper_view.current
                    property: "x"
                    duration: 250
                }

                NumberAnimation
                {
                    target: upper_view.header
                    property: "height"
                    duration: 500
                }

                SequentialAnimation
                {
                    NumberAnimation
                    {
                        target: flash
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 250
                    }

                    NumberAnimation
                    {
                        target: flash
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 250
                    }
                }
            }
        },

        Transition // -------------------------------------------------- ACTIVE_TO_BOTH
        {
            from: "ACTIVE_INTERACTION"
            to: "ACTIVE_AND_INCOMING_INTERACTIONS"

        },

        Transition // -------------------------------------------------- BOTH_TO_IDLE
        {
            from: "ACTIVE_AND_INCOMING_INTERACTIONS"
            to: "IDLE"
        }

    ]
}

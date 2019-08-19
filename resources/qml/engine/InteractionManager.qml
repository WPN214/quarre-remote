import QtQuick 2.0
import Quarre 1.0
import QtQuick.Controls 1.2
import WPN114.Network 1.1 as Network

Item
{
    property string
    module_on_hold

    Network.Node //-------------------------------------------------------------INTERACTION_INCOMING
    {
        id:     interactions_next_incoming
        type:   Network.Type.List
        path:   "/interactions/next/incoming"
        critical: true

        onValueReceived:
        {
            // arg0: title
            // arg1: description
            // arg2: module
            // arg3: length
            // arg4: countdown

            console.log("[INTERACTIONS] Incoming:", newValue);

            if (newValue[0] === undefined || newValue[0] === "")
                return;

            if (newValue[4] === "inf") {
                upper_view.next.count       = -1;
                upper_view.next.countdown   = "inf";
            } else {
                upper_view.next.countdown  = newValue[4];
                upper_view.next.count      = newValue[4];
            }

            upper_view.next.title           = newValue[0];
            upper_view.next.description     = newValue[1];

            upper_view.next.timer.start();

            if (quarre_application.state === "IDLE")
            {
                quarre_application.state    = "INCOMING_INTERACTION";
                grey_animation_in.running   = true;
                module_loader.source        = module_manager.fmt(newValue[ 2 ]);
                module_loader.item.enabled  = false;
            }
            else
                if (quarre_application.state === "ACTIVE_INTERACTION") {
                quarre_application.state = "ACTIVE_AND_INCOMING_INTERACTIONS";
                module_on_hold = module_manager.fmt(newValue[ 2 ]);
            }

            if (flash.opacity > 0)
                flash.opacity = 0;

            system.vibrate(200);
        }
    }

    Network.Node //-------------------------------------------------------------INTERACTION_BEGIN
    {
        id:     interactions_next_begin
        type:   Network.Type.List
        path:   "/interactions/next/begin"
        critical: true

        onValueReceived:
        {
            // arg0: title
            // arg1: description
            // arg2: module
            // arg3: length

            console.log("[INTERACTIONS] Beginning:", newValue);

            if (newValue[0] === undefined || newValue[0] === "")
                return;

            if (newValue[3] === -1 ) {
                upper_view.current.count        = -1;
                upper_view.current.countdown    = "inf";
            } else {
                upper_view.current.count        = newValue[3];
                upper_view.current.countdown    = newValue[3];
            }

            upper_view.current.title            = newValue[0];
            upper_view.current.description      = newValue[1];

            upper_view.current.timer.start();

            upper_view.next.title = "";
            upper_view.next.count = 0;

            upper_view.next.timer.stop();

            if (grey_out_stack.opacity === 0.7)
                grey_animation_out.running = true;

            module_loader.item.enabled = true

            if (quarre_application.state === "IDLE" ||
                quarre_application.state === "INCOMING_INTERACTION")
                quarre_application.state = "ACTIVE_INTERACTION";

            system.vibrate(300);
        }
    }

    Network.Node //--------------------------------------------------------------INTERACTION_NEXT_CANCEL
    {
        id:     interactions_next_cancel
        type:   Network.Type.Impulse
        path:   "/interactions/next/cancel"
        critical: true

        onValueReceived:
        {
            console.log("[INTERACTIONS] Cancelling next" )

            quarre_application.state     = "IDLE";
            module_loader.source         = "../modules/Idle.qml"
            grey_animation_out.running   = true;
            upper_view.next.title        = "";
            upper_view.next.description  = "";
            upper_view.next.count        = 0;

            upper_view.next.timer.stop();

            system.vibrate(50);
        }
    }

    Network.Node //---------------------------------------------------------INTERACTION_END
    {
        id:     interactions_current_end
        type:   Network.Type.Impulse
        path:   "/interactions/current/end"
        critical: true

        onValueReceived:
        {
            if (quarre_application.state === "INCOMING_INTERACTION") {
                interactions_next_cancel.value = 0;
                return;
            }

            upper_view.current.title            = "";
            upper_view.current.description      = "";
            upper_view.current.count            = 0;

            upper_view.current.timer.stop();

            if (quarre_application.state === "ACTIVE_INTERACTION") {
                quarre_application.state    = "IDLE";
                module_loader.item.enabled  = false;
                module_loader.source        = "../modules/Idle.qml"
            }
            else
                if (quarre_application.state === "ACTIVE_AND_INCOMING_INTERACTIONS") {
                    quarre_application.state = "INCOMING_INTERACTION";
                    if (module_on_hold != "") {
                        module_loader.item.enabled = false;
                        module_loader.source = module_on_hold;
                        module_loader.item.enabled = false;
                        grey_animation_in.running = true;
                    }
                }

            system.vibrate(100);
        }
    }

    Network.Node //--------------------------------------------------------- INTERACTION_FORCE
    {
        id:     interactions_current_force
        type:   Network.Type.String
        path:   "/interactions/current/force"
        critical: true

        onValueReceived:
        {
            if (newValue === "" || newValue === undefined)
                return;

            quarre_application.state        = "IDLE";
            upper_view.header.scene.text    = "playground";
            module_loader.source            = module_manager.fmt(newValue);

            system.vibrate(100);
        }
    }

    Network.Node //--------------------------------------------------------- INTERACTIONS_RESET
    {
        id:     interactions_reset
        type:   Network.Type.Impulse
        path:   "/interactions/reset"
        critical: true

        onValueReceived: {
            interactions_current_end.value = 0;
            interactions_next_cancel.value = 0;
        }
    }
}

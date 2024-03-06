import icons from "lib/icons";
import screenrecord from "service/screenrecord";
import { SimpleToggleButton } from "../components/ToggleButton";

export const ScreenRecordToggle = () =>
    SimpleToggleButton({
        icon: icons.recorder.recording,
        label: screenrecord
            .bind("recording")
            .as((r) => (r ? "recording" : "record")),
        toggle: () =>
            screenrecord.recording
                ? (() => {
                      screenrecord.stop();
                  })()
                : (() => {
                      App.closeWindow("quickmenu");
                      App.openWindow("recorder");
                  })(),
        connection: [screenrecord, () => !screenrecord.recording],
    });

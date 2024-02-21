import { SimpleToggleButton } from "../ToggleButton";
import icons from "lib/icons";
import screenrecord from "service/screenrecord";

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
                      screenrecord.start();
                      App.toggleWindow("quicksettings");
                  })(),
        connection: [screenrecord, () => !screenrecord.recording],
    });

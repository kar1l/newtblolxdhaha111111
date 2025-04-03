#Persistent
#SingleInstance Force
#NoTrayIcon
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

pixel_colors := [0x148d91]
pixel_sens := 15
exit_key := "["
toggle_key := "Z"
interval := 0
groupbox_width := 50
groupbox_height := 100
box_width := groupbox_width
box_height := groupbox_height

centerX := A_ScreenWidth // 2 - groupbox_width // 2  ; Fix center alignment
centerY := A_ScreenHeight // 2 - groupbox_height // 2

triggerbot_enabled := false
color_detected := false

Gui, Color, EEAA99
Gui, Font, S37, Arial Black
Gui, Add, GroupBox, w%groupbox_width% h%groupbox_height% cFFB10F BackgroundTrans,
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, EEAA99
Gui -Caption
Gui, Show, NoActivate

Hotkey, %toggle_key%, ToggleTriggerbot
Hotkey, %exit_key%, ExitScript
Return

ToggleTriggerbot:
    triggerbot_enabled := !triggerbot_enabled
    If (triggerbot_enabled) {
        Gui, Show, NoActivate
        SetTimer, PixelDetection, %interval%
        color_detected := false
    } Else {
        Gui, Hide
        SetTimer, PixelDetection, Off
    }
Return

PixelDetection:
    If !triggerbot_enabled
        Return
    for index, pixel_color in pixel_colors {
        PixelSearch, FoundX, FoundY, centerX, centerY, centerX + box_width, centerY + box_height, pixel_color, pixel_sens, Fast RGB
        If !(ErrorLevel) {
            If !color_detected {
                SendInput {Click}
                color_detected := true
            }
            Return
    }
}

    If color_detected {
        triggerbot_enabled := false
        SetTimer, PixelDetection, Off
        Gui, Hide
        color_detected := false
    }
Return

ExitScript:
    Gui, Destroy
    ExitApp

/*
AHK v2.0-beta.11
*/

#include ./corelib.ahk
#include ./mainUI.ahk

;; Properties
  hotkeyMap := { color : "LControl & 1"
    , searchPoint1 : "LControl & 2"
    , searchPoint2 : "LControl & 3"
    , exit : "Escape"
    , pause : "LControl & P"
  }

;; Instantiation
  UI := mainUI()
  UI.window.show()
  UI.hotkeyGroup.update(hotkeyMap)

;; Hotkeys
  hotkey(hotkeyMap.color, (*) => "Callback function")
  hotkey(hotkeyMap.searchPoint1, (*) => "Callback function")
  hotkey(hotkeyMap.searchPoint2, (*) => "Callback function")
  hotkey(hotkeyMap.exit, (*) => quit())


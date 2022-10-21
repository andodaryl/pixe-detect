/*
AHK v2.0-beta.11
*/

#include ./corelib.ahk
#include ./ui-template-main.ahk
#include ./searchAPI.ahk

;; Properties
  coordmode("mouse", "screen")
  coordmode("pixel", "screen")
  hotkeyMap := { color : "LControl & 1"
    , searchPoint1 : "LControl & 2"
    , searchPoint2 : "LControl & 3"
    , exit : "Escape"
    , toggle : "LControl & P"
  }

;; Instantiation
  UI := mainUI()
  UI.window.show()
  UI.hotkeyGroup.update(hotkeyMap)
  search_instance := search()

;; Hotkeys
  hotkey(hotkeyMap.color, (*) => UI.colorList.addColor(getColor()))

  hotkey(hotkeyMap.searchPoint1, (*) => UI.searchPoints.setPoints({COORD1: getCoordinates()}))

  hotkey(hotkeyMap.searchPoint2, (*) => UI.searchPoints.setPoints({COORD2: getCoordinates()}))

  #maxthreadsperhotkey 2
  hotkey(hotkeyMap.toggle, (*) => search_instance.checkIsActive() ?  deactivationAction() : activationAction() )
  deactivationAction() {
    UI.indicator.isInactive()
    search_instance.deactivate()
  }
  activationAction() {
    UI.indicator.isActive()
    search_instance.activate()
  }

  hotkey(hotkeyMap.exit, (*) => quit())


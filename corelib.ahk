/*
AHK v2.0-beta.11
*/

/*
DATABASE
*/

dbFile := "data.ini"

/*
HOTKEYS
*/

hkQuit := "Esc"

/*
DIMENSIONS
*/

; viewport

vh(percentage) {
  return percentage*(A_ScreenHeight/100)
}

vw(percentage) {
  return percentage*(A_ScreenWidth/100)
}

; supporting methods

clamp(dimension, max) {
  return dimension < max ? dimension : max
}

dimensions(dimension_Obj) {

  local stringify := ""

  for dimension, value in dimension_Obj.OwnProps() {
    stringify .= " " . dimension . Integer(value)
  }
  
  return Trim(stringify)

}

/*
METHODS
*/

hotkey(key, func) {
  hotkey %key%, func
}

quit() {
  exitapp
}
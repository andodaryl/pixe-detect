/*
AHK v2.0-beta.11
*/

/*
DATABASE
*/


class Section_Entry {

  __isProp(x) {
    return x ~= "^_.*_$" ;; starts and ends w underscore e.g. "_sample_"
  }

  __New(sectionName, fileName := "data.ini") {
    this._file_ := fileName
    this._name_ := sectionName 
  }

  __Get(keyName, params_array) {

    ;; if property then get from object instance otherwise get from ini file
    return this.__isProp(keyName) ? this.GetOwnPropDesc(keyName).Value : iniread(this._file_, this._name_, keyName)

  }

  __Set(keyName, params_array, value) {

    ;; if property then set new pair in object instance otherwise in ini file
    this.__isProp(keyName) ? this.defineprop(keyName, { Value : value }) : iniwrite(value, this._file_, this._name_, keyName)

  }

}

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

strJoin(array, separator := ", ") {

  string := ""

  for _, value in array {
    string .= separator . value
  }

  return trim(string, separator)

}

parsePairArray(pair_string) {
  return strSplit(pair_string, "=")
}

parseSectionObj(section_string) {

  section_obj := {}

  pairString_array := strSplit(section_string, "`n")

  for pair_string in pairString_array {
    pair_array := parsePairArray(pair_string)
    key := pair_array[1]
    value := pair_array[2]
    section_obj.%key% := value
  }

  return section_obj

}

parseIniObj(file) {

  ini_obj := {}

  sectionNameList_string := iniread(file)

  sectionNameList_array := strSplit(sectionNameList_string, "`n")

  for section_name in sectionNameList_array {
    section_string := iniread(file, section_name)
    section_obj := parseSectionObj(section_string)
    ini_obj.%section_name% := section_obj
  }

  return ini_obj

}
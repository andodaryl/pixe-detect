/*
AHK v2.0-beta.11
*/

#include ./corelib.ahk

/*
UI Object
*/

mainUI() {

  ; Characteristics

  self := gui()
  opt := "-MinimizeBox -MaximizeBox -SysMenu +AlwaysOnTop +ToolWindow -Caption"
  dim := { x: vw(65), y: vh(10), w: 335, h: 302 }

  ; Controls

    ; Color List - Constructor
    _colorList(targetGui) {

      storeData := Section_Entry("colorList")

      defaultData := { itemList : ["—— ( Please add a color ) ——"]
      , disabledItems : []
      , _list : { options : "x17 y19 w155 h22 R3 Choose1" }
      , _box : { options : "x189 y20 w90 h18", text : "Color Disabled"}
      }

      ;; create controls using default data & initialise w stored data
      _list := targetGui.AddDDL(defaultData._list.options, defaultData.itemList)
      _box := targetGui.AddCheckBox(defaultData._box.options, defaultData._box.text)
      update()

      ;; event handling
      _list.OnEvent("Change", syncBoxState)
      _box.OnEvent("Click", storeItemState)

      ;; methods
      syncBoxState(*) {
        if (_list.Text != getEmptyMessage()) {
          _box.Enabled := true
          isItemEnabled(_list.Text) ? _box.Value := 0 : _box.Value := 1
        } else {
          _box.Enabled := false
        }
      } 

      storeItemState(*) {
        switch(_box.Value) {
          case -1: ;; early exit when control is disabled
            return 
          case 0: ;; item should be tagged as enabled
            enableItem(_list.Text)
            return
          case 1: ;;; item should be tagged as disabled
            disableItem(_list.Text)
            return
          default:
            throw Error("Invalid value")
        }
      }

      update(*) {

        ;; re-create list using storeData
        list_array := getItemListArray()
        _list.Delete() ; clear list
        _list.Add(list_array) ; add itemList found or default []
        _list.Choose(1)

        syncBoxState()

      }

      getEmptyMessage() {
        return emptyMessage := defaultData.itemList[1]
      }

      getItemListArray(noTitle := false) {

        isEmpty := storeData.itemList == _null_ || storeData.itemList == ""
        list_array := isEmpty ? defaultData.itemList : strSplit(storeData.itemList, ", ")

        if (noTitle) {
          indexFound := indexOf(list_array, getEmptyMessage())
          if (indexFound) {
            list_array.removeAt(indexFound)
          }
        }

        return list_array

      }

      getDisabledItemsArray() {
        isEmpty := storeData.disabledItems == _null_ || storeData.disabledItems == ""
        return isEmpty ? defaultData.disabledItems : strSplit(storeData.disabledItems, ", ")
        
      }

      isItemEnabled(itemText) {
        list_array := getDisabledItemsArray()
        return indexOf(list_array, itemText) == 0
      }

      enableItem(itemText) {
        if (!isItemEnabled(itemText) && itemText != getEmptyMessage()) {
          list_array := getDisabledItemsArray()
          list_array.removeAt(indexOf(list_array, itemText))
          list_string := strJoin(list_array, ", ")
          storeData.disabledItems := list_string
        }
      }

      disableItem(itemText) {
        if (isItemEnabled(itemText && itemText != getEmptyMessage())) {
          list_array := getDisabledItemsArray()
          list_array.Push(itemText)
          list_string := strJoin(list_array, ", ")
          storeData.disabledItems := list_string
        }
      }

      addColor(_closureFix_, color) {

        list_array := getItemListArray(noTitle := true)

        if (indexOf(list_array, color) == 0) {
          list_array.Push(color)
          list_string := strJoin(list_array, ", ")
          storeData.itemList := list_string
        }

      }

      API := { update : update
      , addColor : addColor
      }

      return API

    }

    ; Search Points - Constructor
    _searchPoints(targetGui) {

      ;; Constructors
      _point1(targetGui) {
        _button := targetGui.AddButton("x16 y59 w155 h22", "Search Area Point 1")
        _edit := targetGui.AddEdit("x189 y59 w120 h21 +ReadOnly")
        return _edit
      }
      _point2(targetGui) {
        _button := targetGui.AddButton("x16 y99 w155 h23", "Search Area Point 2")
        _edit := targetGui.AddEdit("x189 y100 w120 h21 +ReadOnly")
        return _edit
      }

      ;; Instances
      point1 := _point1(targetGui)
      point2 := _point2(targetGui)

      ;; Methods
      update(_closureFix_, COORD1, COORD2) {
        point1.Text := getCoordString(COORD1)
        point2.Text := getCoordString(COORD2)
      }

      getCoordString(COORD) {
        if(COORD.X && COORD.Y) {
          return "(" . COORD.X . "," . COORD.Y . ")"
        }
      }
      
      API := {  update : update
      }

      return API
    }

    ; Hotkey Group - Constructor
    _hotkeyGroup(targetGui) {

      ;; Constructors
      _group(targetGui) {

        ;; Properties
        type_string := "HOTKEYS"
        options := "x15 y138 w304 h142 +Left"

        ;; Instantiate
        targetGui.AddGroupBox(options, type_string)

      }
      
      _exit(targetGui) {

        ;; Properties
        type_string := "Exit"
        options := "x24 y254 w79 h23" 
        
        ;; Helpers
        getText := formatText.Bind(type_string)
        update := (_closureFix_, hotkey_string) => xself.Text := getText(hotkey_string)

        ;; Instantiate
        xself := targetGui.AddText(options, getText())

        return { update : update }

      }
      
      _pause(targetGui) {

        ;; Properties
        type_string := "Pause"
        options := "x24 y229 w283 h23"

        ;; Helpers
        getText := formatText.Bind(type_string)
        update := (_closureFix_, hotkey_string) => xself.Text := getText(hotkey_string)

        ;; Instantiate
        xself := targetGui.AddText(options, getText())


        return { update : update }

      }

      _color(targetGui) {

        ;; Properties
        type_string := "Add Color"
        options := "x24 y159 w281 h23"

        ;; Helpers
        getText := formatText.Bind(type_string)
        update := (_closureFix_, hotkey_string) => xself.Text := getText(hotkey_string)

        ;; Instantiate
        xself := targetGui.AddText(options, getText())

        return { update : update }

      }

      _searchPoint1(targetGui) {

        ;; Properties
        type_string := "Search Point 1"
        options := "x24 y182 w278 h23"

        ;; Helpers
        getText := formatText.Bind(type_string)
        update := (_closureFix_, hotkey_string) => xself.Text := getText(hotkey_string)

        ;; Instantiate
        xself := targetGui.AddText(options, getText())

        return { update : update }

      }

      _searchPoint2(targetGui) {

        ;; Properties
        type_string := "Search Point 2"
        options := "x24 y205 w280 h23"

        ;; Helpers
        getText := formatText.Bind(type_string)
        update := (_closureFix_, hotkey_string) => xself.Text := getText(hotkey_string)

        ;; Instantiate
        xself := targetGui.AddText(options, getText())

        return { update : update }

      }

      ;; Instantiate
      group := _group(targetGui)
      exit := _exit(targetGui)
      pause := _pause(targetGui)
      color := _color(targetGui)
      searchPoint1 := _searchPoint1(targetGui)
      searchPoint2 := _searchPoint2(targetGui)

      ;; Methods
      formatText(type_string, hotkey_string := "HOTKEY") {
        string := type_string . " [ " . hotkey_string . " ]"
        return string
      }

      API := { group : group 
      , exit : exit
      , pause : pause
      , color : color
      , searchPoint1 : searchPoint1
      , searchPoint2 : searchPoint2
      }

      return API

    }

    ; Color List - Instance
    colorList := _colorList(self)

    ; Search Points - Instance
    searchPoints := _searchPoints(self)

    ; Hotkey Group - Instance
    hotkeyGroup := _hotkeyGroup(self)

  ; Event Handling

    self.OnEvent("Escape", self.destroy)

  ; Instantiation

    self.Opt(opt)
    self.Show("hide")
    self.Move(dim.x, dim.y, dim.w, dim.h)

  API := { window : self
    , colorList : colorList
    , searchPoints : searchPoints
    , hotkeyGroup : hotkeyGroup
  }

  return API

}
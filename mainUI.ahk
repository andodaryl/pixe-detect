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

    ; Color List
    colorList(targetGui) {

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

    ; Color List
    colorList2 := colorList(self)

    ; Search Points
    button_SearchP1 := self.AddButton("x16 y59 w155 h22", "Search Area Point 1")
    edit_SearchP1 := self.AddEdit("x189 y59 w120 h21 +ReadOnly")

    button_SearchP2 := self.AddButton("x16 y99 w155 h23", "Search Area Point 2")
    edit_SearchP2 := self.AddEdit("x189 y100 w120 h21 +ReadOnly")

    ; Hotkey Group
    group_Hotkey := self.AddGroupBox("x15 y138 w304 h142 +Left", "HOTKEYS")
    text_Exit := self.AddText("x24 y254 w79 h23", "Exit [ HOTKEY ]")
    text_Pause := self.AddText("x24 y229 w283 h23", "Pause [ HOTKEY ]")
    text_Color := self.AddText("x24 y159 w281 h23", "Add Color [ HOTKEY ]")
    text_SearchP1 := self.AddText("x24 y182 w278 h23", "Search Point 1 [ HOTKEY ]")
    text_SearchP2 := self.AddText("x24 y205 w280 h23", "Search Point 2 [ HOTKEY ]")

    ; Window
    self.OnEvent("Escape", self.destroy)

  ; Instantiation

  self.Opt(opt)
  self.Show("hide")
  self.Move(dim.x, dim.y, dim.w, dim.h)

  return self 

}
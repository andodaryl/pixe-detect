/*
AHK v2.0-beta.11
*/

#include ./corelib.ahk

/*
UI Object
*/

mainUI() {

  ; Characteristics

  self := gui(,, mainUI_eventHandler)
  opt := "-MinimizeBox -MaximizeBox -SysMenu +AlwaysOnTop +ToolWindow -Caption"
  dim := { x: vw(65), y: vh(10), w: 335, h: 302 }

  ; Controls

  dlist_ColorList := self.AddDDL("vColorChoice Choose1 x17 y19 w155 h22", ["Color List"])

  check_Disable := self.AddCheckBox("x189 y20 w57 h18 Disabled", "Disable")

  button_SearchP1 := self.AddButton("x16 y59 w155 h22", "Search Area Point 1")
  edit_SearchP1 := self.AddEdit("x189 y59 w120 h21 +ReadOnly")

  button_SearchP2 := self.AddButton("x16 y99 w155 h23", "Search Area Point 2")
  edit_SearchP2 := self.AddEdit("x189 y100 w120 h21 +ReadOnly")

  group_Hotkey := self.AddGroupBox("x15 y138 w304 h142 +Left", "HOTKEYS")
  text_Exit := self.AddText("x24 y254 w79 h23", "Exit [ HOTKEY ]")
  text_Pause := self.AddText("x24 y229 w283 h23", "Pause [ HOTKEY ]")
  text_Color := self.AddText("x24 y159 w281 h23", "Add Color [ HOTKEY ]")
  text_SearchP1 := self.AddText("x24 y182 w278 h23", "Search Point 1 [ HOTKEY ]")
  text_SearchP2 := self.AddText("x24 y205 w280 h23", "Search Point 2 [ HOTKEY ]")

  self.OnEvent("Escape", self.destroy)

  ; Instantiation

  self.Opt(opt)
  self.Show("hide")
  self.Move(dim.x, dim.y, dim.w, dim.h)

  return self 

}

mainUI_eventHandler(event) {
  return event
}
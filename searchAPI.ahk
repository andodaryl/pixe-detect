#include ./corelib.ahk

; Select color
  getColor() {
    COORD := getCoordinates()
    return pixelGetColor(COORD.x, COORD.y)
  }

; Get Coordinates
  getCoordinates() {
    MouseGetPos(&x, &y )
    return {x: x, y: y}
  }

; Search Loop
  search() {
    
    ;; Properties

      storeData := { ColorList : Section_Entry("ColorList")
        , SearchPoints : Section_Entry("SearchPoints")
      }

      properties := { stopSignal : -1 ;; [-1] initial [0] no stopSignal [1] stopSignal active
        , pixelVariation : 10 ;; 0 - 255
        , color_array : false
        , area_obj : false
        , action : (*) => msgbox("Found!") ;; sample action
      }

    ;; Methods

      activate(*) {
        ;; early exit if already active
          if(checkIsActive()) {
            return
          }
        ;; get most up to date values from database
          properties.color_array := getColorArray()
          properties.area_obj := getArea()
        ;; early exit if not ready
          if(!checkIsReady()) { 
            msgbox("Not ready!")
            return
          }
        ;; reset stopSignal
          properties.stopSignal := 0
        ;; initiate loop
          loop {
            ;; break loop early if stopSignal
              if (properties.stopSignal) { 
                break 
              }
            ;; main search behaviour
              searchArray()
          }
      }

      deactivate(*) {
        properties.stopSignal := 1
      }

      searchArray() {

        ;; properties
          COORD1 := properties.area_obj.COORD1
          COORD2 := properties.area_obj.COORD2
          color_array := properties.color_array
          variation := properties.pixelVariation

        ;; iterate search behaviour per color in array
          for _, color in color_array {
            ;; main pixel search
              pixelSearch(&xFound, &yFound, COORD1.x, COORD1.y, COORD2.x, COORD2.y, color, variation)
            ;; trigger action if found & exit
              if (xFound && yFound) { 
                return properties.action() 
              }
          }

      }

      checkIsActive(*) {
        return properties.stopSignal == 0
      }

      checkIsReady() {

          COORD1 := properties.area_obj.hasOwnProp("COORD1") ? properties.area_obj.COORD1 : false
          COORD2 := properties.area_obj.hasOwnProp("COORD2") ? properties.area_obj.COORD2 : false

          area_obj := isInteger(COORD1.x) && isInteger(COORD1.y) && isInteger(COORD2.x) && isInteger(COORD2.y)
          color_array := properties.color_array is Array && properties.color_array.length > 0

          return area_obj && color_array

      }

      getColorArray() {

        ;; lists from database
          list_array := storeData.ColorList.itemList == _null_ ? [] : strSplit(storeData.ColorList.itemList, ", ")
          disabledItems_array := storeData.ColorList.disabledItems == _null_ ? [] : strSplit(storeData.ColorList.disabledItems, ", ")

        ;; remove disabled items from list_array
          if (list_array.length > 0 && disabledItems_array.length > 0) {
            for _, color in disabledItems_array {
              indexFound := indexOf(list_array, color)
              if (indexFound) {
                list_array.removeAt(indexFound)
              }
            }
          }

        return list_array

      }

      getArea() {
        COORD1 := { x : storeData.SearchPoints.x1, y : storeData.SearchPoints.y1 }
        COORD2 := { x : storeData.SearchPoints.x2, y : storeData.SearchPoints.y2 }
        return { COORD1 : COORD1, COORD2 : COORD2 }
      }

      bindAction(_closureFix_, func) {
        properties.action := func
      }

    ;; API
      API := { activate : activate
        , deactivate : deactivate
        , checkIsActive : checkIsActive
        , bindAction : bindAction
      }

    return API

}
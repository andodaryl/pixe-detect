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
        , action : () => msgbox("Found!") ;; sample action
      }

    ;; Methods

      activate(*) {
        if(checkIsActive()) { return } ;; early exit if already active
        properties.color_array := getColorArray() ;; get most up to date values from database
        properties.area_obj := getArea()
        properties.stopSignal := 0 ;; reset stopSignal
        loop {
          if (properties.stopSignal) { break } ;; break loop if stopSignal
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
            pixelSearch(&xFound, &yFound, COORD1.x, COORD1.y, COORD2.x, COORD2.y, color, variation)
            if (xFound || yFound) { return properties.action() } ;; trigger action if found & exit
          }

      }

      checkIsActive(*) {
        return properties.stopSignal == 0
      }

      getColorArray() {

        ;; lists from database
          list_array := strSplit(storeData.ColorList.itemList, ", ")
          disabledItems_array := strSplit(storeData.ColorList.disabledItems, ", ")

        ;; remove disabled items from list_array
          for _, color in disabledItems_array {
            list_array.removeAt(indexOf(list_array, color))
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
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
  search(Area_obj, color_array) {
    
    ;; Properties
      properties := { stopSignal : -1 ; [-1] initial [0] no stopSignal [1] stopSignal active
        , pixelVariation : 10 ;; 0 - 255
        , pixelFound : false
      }

    ;; Methods
      activate(*) {
        properties.stopSignal := 0 ; 
        loop {
          if (properties.stopSignal) {
            break
          } else {
            searchArray()
          }
        }
      }

      deactivate(*) {
        properties.stopSignal := 1
      }

      searchArray() {
        for index, color in color_array {

          pixelSearch(&xFound, &yFound, Area_obj.COORD1.x, Area_obj.COORD1.y, Area_obj.COORD2.x, Area_obj.COORD2.y, color, properties.pixelVariation)

          if (xFound || yFound) {
            msgbox("Found!")
            return { x: xFound, y: yFound }
          }

        }
      }

      getResult(*)  {
        return properties.result
      }

      checkIsActive(*) {
        return properties.stopSignal == 0
      }

    ;; API
      API := { activate : activate
        , deactivate : deactivate
        , getResult : getResult
        , checkIsActive : checkIsActive
      }

    return API

}
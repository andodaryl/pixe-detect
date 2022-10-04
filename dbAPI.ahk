#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

global databaseName := "data"

; Initialise (otherwise use exisiting) ;

if ( !FileExist(databaseName) ) {

  IniWrite, ini=1, %databaseName%, meta

} else if ( dbGet("ini", "meta") != 1 ) {

  IniWrite, ini=1, %databaseName%, meta
  
}
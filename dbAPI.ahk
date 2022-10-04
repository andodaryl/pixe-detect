#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

global databaseName := "data"

; Initialise (otherwise use exisiting) ;

if ( !FileExist(databaseName) ) {

  IniWrite, ini=true, %databaseName%, meta

} else if ( dbGet("ini", "meta") != true ) {

  IniWrite, ini=true, %databaseName%, meta
  
}
Scriptname DTMTools extends Quest  

DTMConfig Property DTConfig Auto

import MiscUtil
import MfgConsoleFunc


function log2(String Context, String Msg, int level = 2, bool showAlways = false)

	log(Context+" - "+Msg,level, showAlways)

endFunction

function log(String Msg, int level = 2, bool showAlways = false)
	
	if DTConfig.showConsoleOutput == true || showAlways == true
		PrintConsole("DTM: "+ Msg)
	endIf
	
	if DTConfig.showTraceOutput == true || showAlways == true
		debug.trace("DTM: "+ Msg)
	endIf
endFunction
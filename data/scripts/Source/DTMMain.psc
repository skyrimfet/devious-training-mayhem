Scriptname DTMMain extends Quest  

DTMConfig Property DTConfig Auto
DTMTools Property DTTools Auto
DTMUpdate Property DTUpdate Auto
DTMActor Property DTActor Auto

;hardcoded version info
Float function getVersion()
	return 1.8
endFunction

;visual version info
String function getDisplayVersion()
	return "1.0"
endFunction


Event OnInit()
	;init
	DTConfig.modEnabled = true
	DTConfig.showConsoleOutput = true
	DTConfig.showTraceOutput = true
	DTConfig.lastVersion = 0
	DTUpdate.Update(getVersion())
	Utility.wait(5.0)
	startMod()
EndEvent

function stopMod()
	DTConfig.modEnabled = false
	stopEvents()
endFunction

function startMod()
	DTConfig.modEnabled = true
	stopEvents()
	initEvents()
	grabActors()
endFunction

function startTimer()
	DTTools.log2("onUpdate","RUN")
	RegisterForSingleUpdate(10.0)
endFunction

Event OnUpdate()
	DTTools.log2("onUpdate","period update")
	;grabAdditionalStats()
	
	if DTConfig.days != Game.QueryStat("Days Passed") 
		DTConfig.days+=1
		grabAdditionalStats()
	endif
	;grabAdditionalStats()
	RegisterForSingleUpdate(10.0)
	
endEvent


function onLoadFunction()
	DTUpdate.Update(getVersion())
	stopEvents()
	if DTConfig.modEnabled == true
		
		initEvents()	
		
		int i = 0
		while i < DTActor.getArrayCount()
			if DTActor.npcs_ref[i]!=None
				DTActor.resetAllChanges(i)
			endif
			i+=1
		endwhile
		
		onLocationChanged()
		grabActors()
	endIf
endFunction

function onLocationChanged()

int i = 0
	while i < DTActor.getArrayCount()
		if DTActor.npcs_ref[i]!=None
			;i had no idea:()
			DTActor.updateBreasts(i, DTActor.npcs_ref[i].GetFactionRank(DTConfig.DT_Chastitybra))
			if DTActor.npcs_ref[i].hasSpell(DTConfig.EffectSpell)
				DTActor.npcs_ref[i].removeSpell(DTConfig.EffectSpell)				
			endif			
			DTActor.npcs_ref[i].addSpell(DTConfig.EffectSpell,false)
			
		endif
		i+=1
	endwhile

endFunction


function grabActors()
	DTTools.log2("CallEvent","DT_Ping")
	int handle = ModEvent.Create("DT_Ping") 
	ModEvent.pushString(handle,"DTM")
	ModEvent.Send(handle)		
endFunction


function grabAdditionalStats()
	DTTools.log2("CallEvent","DT_AdditionalStats")
	int handle = ModEvent.Create("DT_AdditionalStats") 
	ModEvent.pushString(handle,"DTM")
	ModEvent.Send(handle)		
	
endFunction




function initEvents()
	RegisterForModEvent("DT_ActorRegister", "eventRegister")
	RegisterForModEvent("DT_ActorUnRegister", "eventUnRegister")
	RegisterForModEvent("DT_ActorLevelChange", "eventLevelUp")
	RegisterForModEvent("DT_CheckActorDTM", "eventCheckActor")
	RegisterForModEvent("DT_AdditionalStatsActorDTM", "eventAdditionalStatsActor")
	RegisterForModEvent("DT_Updated", "eventUpdate")
	UnregisterForModEvent("DT_SendStatus")
	RegisterForModEvent("DT_SendStatus", "eventStatus")
	
endFunction

function stopEvents()
	UnregisterForModEvent("DT_ActorRegister")
	UnregisterForModEvent("DT_ActorUnRegister")
	UnregisterForModEvent("DT_ActorLevelChange")
	UnregisterForModEvent("DT_CheckActorDTM")
	UnregisterForModEvent("DT_AdditionalStatsActorDTM")
	UnregisterForModEvent("DT_Updated")
	
endFunction

Event eventStatus(string status)

	DTTools.log2("Status", status)
	debug.notification("STATUS IS:"+status)

	updateActors()
	
	
	if status == "disable" || status == "uninstall"
		DTConfig.modEnabled = false
		int i = 0
		while i < DTActor.getArrayCount()
			if DTActor.npcs_ref[i]!=None
		
				if DTActor.npcs_ref[i].hasSpell(DTConfig.EffectSpell)
					DTActor.npcs_ref[i].removeSpell(DTConfig.EffectSpell)				
				endif			
				DTActor.resetAllChanges(i)
			
			endif
			i+=1
		endwhile
	endif
	
	if status == "enable"
		if DTConfig.modEnabled == false
			startMod()			
		endif
	endif	
	
	if status == "uninstall"
		stopMod()
		int i = 0
		while i < DTActor.getArrayCount()
			if DTActor.npcs_ref[i]!=None
				DTActor.unregisterActor(DTActor.npcs_ref[i],i)
			endif
			i+=1
		endwhile		
		UnregisterForModEvent("DT_SendStatus")
	endif
endEvent

Event eventUpdate(float version)
	
	updateActors()
	onLocationChanged()
endEvent

function updateActors()
	int i = 0
	while i < DTActor.getArrayCount()
		if DTActor.npcs_ref[i]!=None
			DTActor.processActor(i)
		endif
		i+=1
	endwhile

endFunction

Event eventAdditionalStatsActor(Form akActorForm,int modIndex,int orgasm,int steps, int dmg,int dmgZad, int days)
	DTTools.log2("orgasm",orgasm)
	DTTools.log2("steps",steps)
	DTTools.log2("dmg",dmg)
	DTTools.log2("dmgZad",dmgZad)
	DTTools.log2("days",days)
	
	DTActor.processActor(modIndex, "weight", steps , orgasm)
	DTActor.processActor(modIndex, "tats_days", days)
	DTActor.processActor(modIndex, "tats_hitsZad", dmgZad)
	
endEvent

Event eventCheckActor(Form akActorForm,int modIndex)
	actor akActor = akActorForm as Actor
	DTActor.registerActor(akActor,modIndex)
	DTActor.processActor(modIndex)
endEvent

Event eventRegister(Form akActorForm,int modIndex)
	actor akActor = akActorForm as Actor
	
	DTActor.registerActor(akActor,modIndex)
	
endEvent


Event eventUnRegister(Form akActorForm,int modIndex)
   actor akActor = akActorForm as Actor
   DTActor.unregisterActor(akActor,modIndex)
   
endEvent

Event eventLevelUp(Form akActorForm,int modIndex,String itemname, int oldlevel, int newlevel)
   actor akActor = akActorForm as Actor
   DTActor.processActor(modIndex, itemname, newlevel)
    ;DTTools.log2("eventUnRegister",akActorForm)
	;DTTools.log2("eventUnRegister",itemname)
	;DTTools.log2("eventUnRegister",oldlevel)
	;DTTools.log2("eventUnRegister",newlevel)
   
	;debug.trace("eventLevelUp")
	;debug.trace(akActor)
	;debug.trace(itemname)
	;debug.trace(oldlevel)
	;debug.trace(newlevel)
	;debug.notification("akActor")
	;debug.notification("eventLevelUp")
endEvent
Scriptname DTMScriptEffect extends activemagiceffect  

DTMMain Property DTMain Auto
DTMActor Property DTActor Auto
DTMStorage Property DTStorage Auto
DTMConfig Property DTConfig Auto 

Int Slot
Bool Enabled
Bool waitForProcess 

zadLibs Property libs Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)


	Slot = DTActor.isRegistered(akTarget)
	
	if Slot == -1	
		self.Dispel()
	endIf
	
;	Terminate = False;
	;acActor = akTarget
	
	RegisterForSingleUpdate(5.0)
	Enabled = true
	UpdateEyes()
	UpdateMouth()
endEvent

Event OnEffectFinish(Actor acActor, Actor akCaster)
	Enabled = false
endEvent

Event OnObjectUnEquipped(Form akBaseObject, ObjectReference akReference)
	;debug.notification("removed item... "+Slot)
	;debug.notification("rank is (colar)"+DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_Collar))
	;debug.notification("rank is"+DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_VaginalPlug))
	;if DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_VaginalPlug)>=4
	;debug.notification("try to add")
;		if DTActor.npcs_ref[Slot].GetWornForm(DTConfig.slotMask[57]) as Armor == none;
			;DTActor.npcs_ref[Slot].addItem(DTStorage.DTMVagGap,1,true)
			;DTActor.npcs_ref[Slot].EquipItem(DTStorage.DTMVagGap,false,true)
		;endif
	
	;endif
	
	;if DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_AnalPlug)>=4
	;debug.notification("try to add")
	;	if DTActor.npcs_ref[Slot].GetWornForm(DTConfig.slotMask[48]) as Armor == none
	;		DTActor.npcs_ref[Slot].addItem(DTStorage.DTMAnalGap,1,true)
	;		DTActor.npcs_ref[Slot].EquipItem(DTStorage.DTMAnalGap,false,true)
	;	endif
	
	;endif
	DTActor.processActor(Slot,"analplug",2)
	DTActor.processActor(Slot,"vaginalplug",2)
	;utility.wait(.0)
	;DTActor.processActor(Slot,"collar", DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_Collar))
	;DTActor.processActor(Slot,"corset",DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_Corset))
	
	if (akBaseObject.HasKeyword(libs.zad_DeviousCollar) || akBaseObject.HasKeyword(libs.zad_DeviousCorset) || akBaseObject.HasKeyword(libs.zad_DeviousBelt) || akBaseObject.HasKeyword(libs.zad_DeviousHarness))
		inventoryEventPost()
	endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	
	if (akBaseObject.HasKeyword(libs.zad_DeviousCollar) || akBaseObject.HasKeyword(libs.zad_DeviousCorset) || akBaseObject.HasKeyword(libs.zad_DeviousBelt) || akBaseObject.HasKeyword(libs.zad_DeviousHarness))
		inventoryEventPost()
	endif
	
			
EndEvent

function inventoryEventPost()
	if waitForProcess == true
		return
	endif
	utility.wait(2.0)
	waitForProcess = true
	DTActor.processActor(Slot,"collar",DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_Collar))
	DTActor.processActor(Slot,"corset",DTActor.npcs_ref[Slot].GetFactionRank(DTConfig.DT_Corset))
	waitForProcess = false
endFunction

Event OnUpdate()	
	if Enabled == false
		self.Dispel()
		return
	endif
	UpdateEyes()
	UpdateMouth()
	
	RegisterForSingleUpdate(5.0)
EndEvent


Function UpdateEyes()
DTActor.updateEyes(Slot)
endFunction

Function UpdateMouth()
DTActor.updateMouth(Slot)
endFunction


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Utility.wait(0.5)
	DTMain.grabAdditionalStats()
endEvent
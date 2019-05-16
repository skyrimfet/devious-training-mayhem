Scriptname DTMUpdate extends Quest  

DTMStorage Property DTStorage Auto
DTMConfig Property DTConfig Auto
DTMTools Property DTTools Auto
DTMActor Property DTActor Auto
DTMMain Property DTMain Auto


Function Update(Float version)

	
	DTTools.log("Update - Check for updates...",2, true)
	updateOnEveryLoad()
	if version <= DTConfig.lastVersion
		DTTools.log("Update - Not update requied",2, true)
		return
	endIf

	DTTools.log("Update DTM - version:"+version+" START", 2, true)

	updateAlwyas()	
	
	if DTConfig.lastVersion < 0.1
		DTTools.log("Run module updateTo01",2, true)
		updateTo01()
	endIf	
	if DTConfig.lastVersion < 1.1
		DTTools.log("Run module updateTo11",2, true)
		updateTo11()
	endIf	
	if DTConfig.lastVersion < 1.2
		DTTools.log("Run module updateTo12",2, true)
		updateTo12()
	endIf		
	if DTConfig.lastVersion < 1.3
		DTTools.log("Run module updateTo13",2, true)
		updateTo13()
	endIf	
	if DTConfig.lastVersion < 1.4
		DTTools.log("Run module updateTo14",2, true)
		updateTo14()
	endIf		
	if DTConfig.lastVersion < 1.5
		DTTools.log("Run module updateTo15",2, true)
		updateTo15()
	endIf	
	if DTConfig.lastVersion < 1.6
		DTTools.log("Run module updateTo16",2, true)
		updateTo16()
	endIf	
	if DTConfig.lastVersion < 1.7
		DTTools.log("Run module updateTo17",2, true)
		updateTo17()
	endIf
	if DTConfig.lastVersion < 1.8
		DTTools.log("Run module updateTo18",2, true)
		updateTo18()
	endIf	
	DTTools.log("Update DTM - version:"+version+" FINISH",2, true)
	
	DTMain.grabAdditionalStats();
	
	DTConfig.lastVersion = version

EndFunction


function updateTo18()
	DTConfig.compressedBreasts = true
endFunction
function updateTo17()
	DTConfig.allowItemoverlays = false
endFunction

function updateTo16()

	DTTools.log("Update DTM [1.6] START",2, true)
	int i = 0
	while i < DTActor.getArrayCount()
		if DTActor.npcs_ref[i]!=none
			DTTools.log("Update DTM [1.6]   Remove body changes for slot: "+i,2, true)
			NiOverride.RemoveNodeTransformScale(DTActor.npcs_ref[i],False,True,"NPC R Calf [LClf]","Devious Training Mayhem")    
			NiOverride.RemoveNodeTransformScale(DTActor.npcs_ref[i],False,True,"NPC R Calf [RClf]","Devious Training Mayhem")
			NiOverride.RemoveNodeTransformScale(DTActor.npcs_ref[i],False,True,"NPC L Thigh [LThg]","Devious Training Mayhem")    
			NiOverride.RemoveNodeTransformScale(DTActor.npcs_ref[i],False,True,"NPC R Thigh [RThg]","Devious Training Mayhem")
			NiOverride.UpdateNodeTransform(DTActor.npcs_ref[i], false, True, "NPC R Calf [LClf]") 
			NiOverride.UpdateNodeTransform(DTActor.npcs_ref[i], false, True, "NPC R Calf [RClf]") 
			NiOverride.UpdateNodeTransform(DTActor.npcs_ref[i], false, True, "NPC L Thigh [LThg]") 
			NiOverride.UpdateNodeTransform(DTActor.npcs_ref[i], false, True, "NPC R Thigh [RThg]") 
			
			if DTConfig.modSlif == true
				SLIF_Main.unregisterNode(DTActor.npcs_ref[i], "slif_belly", "Devious Training Mayhem Weight")
				SLIF_Main.unregisterNode(DTActor.npcs_ref[i], "slif_butt", "Devious Training Mayhem Weight")
				SLIF_Main.unregisterNode(DTActor.npcs_ref[i], "slif_breast", "Devious Training Mayhem Weight")
			endif
		endif
		int j = 0
		while j < 90
			DTTools.log("Update DTM [1.6]   Remove old tats for slot: "+i+" / "+j,2, true)
			SlaveTats.simple_remove_tattoo(DTActor.npcs_ref[i], "DTTatsDays", "day"+j)	
			SlaveTats.simple_remove_tattoo(DTActor.npcs_ref[i], "DTTatsScars", "scars_whips"+j)	
			j=j+1
		endwhile
		
		DTActor.npcs_daysInBondageLastKnow[i] = -1
		DTActor.npcs_hitsZadTatStageLastKnow[i] = -1
		i+=1
	endwhile
		

			

endFunction
function updateTo15()
	DTConfig.analPlugEffect = true
	DTConfig.vaginalPlugEffect = true
endFunction

function updateTo14()
	updateAlwyas()
endFunction

function updateTo13()	
	

endFunction

function updateTo12()	
endFunction

function updateTo11()	
	
	DTConfig.supportSteps = true



	


	DTConfig.enableWhipsMarks = true
	DTConfig.days = Game.QueryStat("Days Passed") 
	
	
	DTMain.startTimer()
	
	
	DTActor.npcs_lastKnownSteps = new int[32]

	
	DTActor.npcs_daysInBondage = new int[32]			
	DTActor.npcs_daysInBondageLastKnow = new int[32]
	
	
	DTActor.npcs_lastKnownHitsZad = new int[32]	
	
	DTActor.npcs_hitsZadTatStage = new int[32]			
	DTActor.npcs_hitsZadTatStageLastKnow = new int[32]
	
	

	


	int i = 0
	while i < DTActor.getArrayCount()
		
		DTActor.npcs_lastKnownSteps[i] = 0
		DTActor.npcs_daysInBondage[i] = 0
		DTActor.npcs_daysInBondageLastKnow[i] = 0
		DTActor.npcs_lastKnownHitsZad[i] = 0
		DTActor.npcs_hitsZadTatStage[i] = 0
		DTActor.npcs_hitsZadTatStageLastKnow[i] = 0
		
		

		i+=1
	endwhile
	
	;DTConfig.days = DTConfig.days - 1
	;DTConfig.bodyScaleFactor = 75.0
	
endFunction

function updateTo01()
	updateOnEveryLoad()
	DTConfig.blindfoldScaleEyes = 10
	DTConfig.gagScaleMouth = 80

	DTConfig.corsetScaleWaist = 25
	DTConfig.chastityBeltScaleWaist = 5
	DTConfig.harnessScaleWaist = 2
	
	DTConfig.collarScaleNeck = 30 
	
	DTConfig.chastityBraScaleBreasts = 0.5
	
	DTActor.npcs_ref = new actor[32]
	DTConfig.mcmWorking = false
	int i = 0
	while i < DTActor.getArrayCount()
		DTActor.npcs_ref[i] = None
		i+=1
	endwhile

endFunction

function updateAlwyas()

	DTConfig.DT_Boots = Game.GetFormFromFile(0x08023e6c, "DeviousTraining.esp") as Faction
	DTConfig.DT_Corset = Game.GetFormFromFile(0x08023e6d, "DeviousTraining.esp") as Faction
	DTConfig.DT_Harness = Game.GetFormFromFile(0x08023e6e, "DeviousTraining.esp") as Faction
	DTConfig.DT_Legscuffs = Game.GetFormFromFile(0x08023e6f, "DeviousTraining.esp") as Faction
	DTConfig.DT_Armscuffs = Game.GetFormFromFile(0x08023e70, "DeviousTraining.esp") as Faction
	DTConfig.DT_Gag = Game.GetFormFromFile(0x08023e71, "DeviousTraining.esp") as Faction
	DTConfig.DT_Collar = Game.GetFormFromFile(0x08023e72, "DeviousTraining.esp") as Faction
	DTConfig.DT_Chastitybelt = Game.GetFormFromFile(0x08023e73, "DeviousTraining.esp") as Faction
	DTConfig.DT_Chastitybra = Game.GetFormFromFile(0x08023e74, "DeviousTraining.esp") as Faction
	DTConfig.DT_Gloves = Game.GetFormFromFile(0x08023e75, "DeviousTraining.esp") as Faction
	DTConfig.DT_Armbinderyoke = Game.GetFormFromFile(0x08023e76, "DeviousTraining.esp") as Faction
	DTConfig.DT_Blindfold = Game.GetFormFromFile(0x08023e77, "DeviousTraining.esp") as Faction
	DTConfig.DT_AnalPlug = Game.GetFormFromFile(0x08026988, "DeviousTraining.esp") as Faction
	DTConfig.DT_VaginalPlug = Game.GetFormFromFile(0x08026989, "DeviousTraining.esp") as Faction

	DTConfig.slotMask = new Int[65]
	DTConfig.slotMask[30] = 0x00000001
	DTConfig.slotMask[31] = 0x00000002
	DTConfig.slotMask[32] = 0x00000004
	DTConfig.slotMask[33] = 0x00000008
	DTConfig.slotMask[34] = 0x00000010
	DTConfig.slotMask[35] = 0x00000020
	DTConfig.slotMask[36] = 0x00000040
	DTConfig.slotMask[37] = 0x00000080
	DTConfig.slotMask[38] = 0x00000100
	DTConfig.slotMask[39] = 0x00000200
	DTConfig.slotMask[40] = 0x00000400
	DTConfig.slotMask[41] = 0x00000800
	DTConfig.slotMask[42] = 0x00001000
	DTConfig.slotMask[43] = 0x00002000
	DTConfig.slotMask[44] = 0x00004000
	DTConfig.slotMask[45] = 0x00008000
	DTConfig.slotMask[46] = 0x00010000
	DTConfig.slotMask[47] = 0x00020000
	DTConfig.slotMask[48] = 0x00040000
	DTConfig.slotMask[49] = 0x00080000
	DTConfig.slotMask[50] = 0x00100000
	DTConfig.slotMask[51] = 0x00200000
	DTConfig.slotMask[52] = 0x00400000
	DTConfig.slotMask[53] = 0x00800000
	DTConfig.slotMask[54] = 0x01000000
	DTConfig.slotMask[55] = 0x02000000
	DTConfig.slotMask[56] = 0x04000000
	DTConfig.slotMask[57] = 0x08000000
	DTConfig.slotMask[58] = 0x10000000
	DTConfig.slotMask[59] = 0x20000000
	DTConfig.slotMask[60] = 0x40000000
	DTConfig.slotMask[61] = 0x80000000
	
endFunction

function updateOnEveryLoad()

	DTConfig.EffectSpell = DTStorage.DTMEffects

	bool befModSlif = DTConfig.modSlif

	if (Game.GetModbyName("SexLab Inflation Framework.esp") != 255)
		DTConfig.modSlif = true		
		DTTools.log("check for SexLab Inflation Framework OK!")
	else
		DTConfig.modSlif = false
	endIf	
	
	if befModSlif != DTConfig.modSlif
	
		int i = 0
		while i < DTActor.getArrayCount()
			DTActor.resetAllChanges(i)
			i+=1
		endwhile
		
		DTMain.grabActors()
		
	endIf

endFunction
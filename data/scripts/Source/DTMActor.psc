Scriptname DTMActor extends Quest  

DTMTools Property DTTools Auto
DTMConfig Property DTConfig Auto
DTMStorage Property DTStorage Auto

Actor[] Property npcs_ref Auto


Int[] Property npcs_lastKnownSteps Auto
Int[] Property npcs_lastKnownHitsZad Auto
Int[] Property npcs_hitsZadTatStage Auto
Int[] Property npcs_hitsZadTatStageLastKnow Auto
Int[] Property npcs_daysInBondage Auto
Int[] Property npcs_daysInBondageLastKnow Auto

zadLibs Property libs Auto



import MiscUtil
import MfgConsoleFunc

int function getArrayCount()
	return ( npcs_ref.length - 1 )
endFunction

int function isRegistered(Actor acAktor)
	int i = 0
    while i < getArrayCount()
		if acAktor == npcs_ref[i]
			return i
		endif
		i+=1
	endWhile
	return -1
endFunction

function registerActor(Actor akActor, int Slot)
	
	
	if npcs_ref[Slot]!=akActor
		npcs_ref[Slot] = akActor

		
		npcs_lastKnownSteps[Slot] = 0
		
		npcs_daysInBondage[Slot] = 0
		npcs_daysInBondageLastKnow[Slot] = 0
		npcs_lastKnownHitsZad[Slot] = 0
		npcs_hitsZadTatStage[Slot] = 0
		npcs_hitsZadTatStageLastKnow[Slot] = 0
		
		
		
		processActor(Slot)
		npcs_ref[Slot].addSpell(DTConfig.EffectSpell,false)
	endIf

	
	
	
endFunction


function unregisterActor(Actor akActor, int Slot)
	
	resetAllChanges(Slot)
	
	ActorOverlayRemove(npcs_ref[Slot], "body", "day",true )
	ActorOverlayRemove(npcs_ref[Slot], "body", "scars",true )
	ActorOverlayRemove(npcs_ref[Slot], "body", "itemsoverlays",true )
	;procedure
	npcs_ref[Slot].removeSpell(DTConfig.EffectSpell)
	if npcs_ref[Slot]==akActor
		npcs_ref[Slot] = None
	endIf
	
	
	
	
endFunction


function processActor(int Slot, String item = "", float value = -1.0, float value2 = -1.0)

	

	DTTools.log2("ProcessActor Slot:",Slot)
	DTTools.log2("ProcessActor Item:",item)

	if npcs_ref[Slot] == None
		return
	endIf
	
	;general actor process
	if item == "" && value == -1
		updateBelly(Slot)
		updateWaist(Slot, npcs_ref[Slot].GetFactionRank(DTConfig.DT_Corset), npcs_ref[Slot].GetFactionRank(DTConfig.DT_Harness), npcs_ref[Slot].GetFactionRank(DTConfig.DT_Chastitybelt))
		updateCollar(Slot, npcs_ref[Slot].GetFactionRank(DTConfig.DT_Collar))
		updateBreasts(Slot, npcs_ref[Slot].GetFactionRank(DTConfig.DT_Chastitybra))
		updateAnal(Slot,npcs_ref[Slot].GetFactionRank(DTConfig.DT_AnalPlug))
		updateVaginal(Slot,npcs_ref[Slot].GetFactionRank(DTConfig.DT_VaginalPlug))
		addItemOverlays(Slot)
	endIf
	
	
	
	
	;selected actor process
	if item != "" && value != -1
	
		
		
		if item=="tats_hitsZad"
			processHitsZad(Slot,value as Int)
		endIf
						
		if item=="tats_days"
			processTatDaysTats(Slot,value as Int)
		endIf
	
		if item=="analplug" || item=="AnalPlug"
			updateAnal(Slot,npcs_ref[Slot].GetFactionRank(DTConfig.DT_AnalPlug))
		endif
		
		if item=="vaginalplug" || item=="VaginalPlug"
			updateVaginal(Slot,npcs_ref[Slot].GetFactionRank(DTConfig.DT_VaginalPlug))
		endif
	
		if item=="corset"
			updateWaist(Slot, value as Int, npcs_ref[Slot].GetFactionRank(DTConfig.DT_Harness) , npcs_ref[Slot].GetFactionRank(DTConfig.DT_Chastitybelt))
			updateBelly(Slot)
			addItemOverlays(Slot)
		endIf
		
		if item=="harness"
			updateWaist(Slot, npcs_ref[Slot].GetFactionRank(DTConfig.DT_Corset), value  as Int , npcs_ref[Slot].GetFactionRank(DTConfig.DT_Chastitybelt) )
			addItemOverlays(Slot)
		endIf
	
		if item =="chastitybelt"
			updateWaist(Slot, npcs_ref[Slot].GetFactionRank(DTConfig.DT_Corset), npcs_ref[Slot].GetFactionRank(DTConfig.DT_Harness),  value  as Int)
			addItemOverlays(Slot)
		endif
		
		if item =="collar"
			updateCollar(Slot, value  as Int)
		endif
	
		if item =="chastitybra"
			updateBreasts(Slot, value  as Int)
			addItemOverlays(Slot)
		endif
	
	endIf


endFunction


;add some tats like corset marks etc
function addItemOverlays(int slot)
	if DTConfig.allowItemoverlays==false
		return
	endif
	String binnaryMark = "1_"
	if npcs_ref[Slot].GetFactionRank(DTConfig.DT_Chastitybelt)>0
		binnaryMark = binnaryMark+"1"
	else
		binnaryMark = binnaryMark+"0"
	endif

	if npcs_ref[Slot].GetFactionRank(DTConfig.DT_Chastitybra)>0
		binnaryMark = binnaryMark+"1"
	else
		binnaryMark = binnaryMark+"0"
	endif

	if npcs_ref[Slot].GetFactionRank(DTConfig.DT_Corset)>0
		binnaryMark = binnaryMark+"1"
	else
		binnaryMark = binnaryMark+"0"
	endif

	if npcs_ref[Slot].GetFactionRank(DTConfig.DT_Harness)>0
		binnaryMark = binnaryMark+"1"
	else
		binnaryMark = binnaryMark+"0"
	endif
	if binnaryMark!= "1_0000"
		ActorOverlayAdd(npcs_ref[Slot], "body", "itemsoverlays" , "group"+binnaryMark,true)
	endif
	
endFunction

function resetAllChanges(int Slot)

		NiOverride.RemoveNodeTransformScale(npcs_ref[Slot],False,True,"NPC Spine1 [Spn1]","Devious Training Mayhem")    
		NiOverride.RemoveNodeTransformScale(npcs_ref[Slot],False,True,"NPC Spine2 [Spn2]","Devious Training Mayhem")		
		NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Spine1 [Spn1]") 
		NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Spine2 [Spn2]") 
		
		NiOverride.RemoveNodeTransformScale(npcs_ref[Slot],False,True,"NPC Neck [Neck]","Devious Training Mayhem")    
		NiOverride.RemoveNodeTransformScale(npcs_ref[Slot],False,True,"NPC Head [Head]","Devious Training Mayhem")
		NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Neck [Neck]") 
		NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Head [Head]") 
		

		
		
		if DTConfig.modSlif == true
			SLIF_Main.unregisterNode(npcs_ref[Slot], "NPC Spine1 [Spn1]", "Devious Training Mayhem")
			SLIF_Main.unregisterNode(npcs_ref[Slot], "NPC Spine2 [Spn2]", "Devious Training Mayhem")
			SLIF_Main.unregisterNode(npcs_ref[Slot], "NPC Neck [Neck]", "Devious Training Mayhem")
			SLIF_Main.unregisterNode(npcs_ref[Slot], "NPC Head [Head]", "Devious Training Mayhem")

			SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC L Breast")
			SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC R Breast")
			SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "slif_belly")
			SLIF_Main.unregisterNode(npcs_ref[Slot], "slif_breast", "Devious Training Mayhem")
			
			

		endif
		
		npcs_ref[Slot].unequipItem(DTStorage.DTMAnalGap,1,true)
		npcs_ref[Slot].removeItem(DTStorage.DTMAnalGap,1)
		npcs_ref[Slot].removeItem(DTStorage.DTMAnalGap,1)
		npcs_ref[Slot].unequipItem(DTStorage.DTMAnalGap,1,true)
		npcs_ref[Slot].removeItem(DTStorage.DTMAnalGap,1)
		npcs_ref[Slot].removeItem(DTStorage.DTMAnalGap,1)
		
		ActorOverlayRemove(npcs_ref[Slot], "body", "day",true )
	ActorOverlayRemove(npcs_ref[Slot], "body", "scars",true )
	ActorOverlayRemove(npcs_ref[Slot], "body", "itemsoverlays",true )
endFunction


function updateAnal(int Slot, int rank)
DTTools.log2("Add anal hole",rank)
		DTTools.log2("Add anal hole",Slot)

	if rank >= 4 && DTConfig.analPlugEffect == true
		if npcs_ref[Slot].GetWornForm(DTConfig.slotMask[48]) as Armor == none
			npcs_ref[Slot].addItem(DTStorage.DTMAnalGap,1,true)
			npcs_ref[Slot].EquipItem(DTStorage.DTMAnalGap,false,true)
		endif
	else
		npcs_ref[Slot].unequipItem(DTStorage.DTMAnalGap,1,true)
		npcs_ref[Slot].removeItem(DTStorage.DTMAnalGap,1)
		npcs_ref[Slot].removeItem(DTStorage.DTMAnalGap,1)
	endif
endFunction

function updateVaginal(int Slot, int rank)
	DTTools.log2("Add vag hole",rank)
		DTTools.log2("Add vag hole",Slot)
	if rank >= 4 && DTConfig.vaginalPlugEffect == true
		if npcs_ref[Slot].GetWornForm(DTConfig.slotMask[57]) as Armor == none
			npcs_ref[Slot].addItem(DTStorage.DTMVagGap,1,true)
			npcs_ref[Slot].EquipItem(DTStorage.DTMVagGap,false,true)
		endif
	else
		npcs_ref[Slot].unequipItem(DTStorage.DTMVagGap,1,true)
		npcs_ref[Slot].removeItem(DTStorage.DTMVagGap,1)
		npcs_ref[Slot].removeItem(DTStorage.DTMVagGap,1)
	endif
	
endFunction

function processTatDaysTats(int Slot, int days)
	if (days == 0)
		return
	endif
	if npcs_daysInBondage[Slot]>63			
		npcs_daysInBondage[Slot] = 63
	endif
	
	if npcs_daysInBondageLastKnow[Slot] != days
		ActorOverlayAdd(npcs_ref[Slot], "body", "day" , "day"+days,true)
	endif
	npcs_daysInBondageLastKnow[Slot] = days
	return
	DTTools.log2("DAYS in bondage",days)
	DTTools.log2("DAYS in bondage",npcs_daysInBondageLastKnow[Slot])
	if days == npcs_daysInBondageLastKnow[Slot]
		DTTools.log2("DAYS nothing to do","just bye")
		return
	endif
	npcs_daysInBondage[Slot] = days
	int day = npcs_daysInBondage[Slot]
	int dayMinusOne = npcs_daysInBondage[Slot]
	dayMinusOne-=1
	if npcs_daysInBondageLastKnow[Slot] != day
		SlaveTats.simple_remove_tattoo(npcs_ref[Slot], "DTTatsDays", "day"+day)	
		if (dayMinusOne>0)
			SlaveTats.simple_remove_tattoo(npcs_ref[Slot], "DTTatsDays", "day"+dayMinusOne)				
		endif
		SlaveTats.simple_add_tattoo(npcs_ref[Slot], "DTTatsDays", "day"+day)
		npcs_daysInBondageLastKnow[Slot] = day
	endif
endFunction

function processHitsZadTats(int Slot, int count)

	if count == 0
		return 
	endif

	if count > 75
		count = 75
	endif

	DTTools.log2("zadWhipsTat",count)
	if npcs_hitsZadTatStage[Slot]>75			
		return
	endif
	
	
	if (npcs_hitsZadTatStageLastKnow[Slot] != count)
		ActorOverlayAdd(npcs_ref[Slot], "body", "scars" , "scars_whips"+count,true)
	endif
	
	npcs_hitsZadTatStageLastKnow[Slot] = count
	return
	
	
	npcs_hitsZadTatStage[Slot] = count
	DTTools.log2("zadWhipsTat(lastKnown)",npcs_hitsZadTatStageLastKnow[Slot])
	if npcs_hitsZadTatStageLastKnow[Slot] != count
		int i = 1
		while i < count
			if DTConfig.enableWhipsMarks == true
				SlaveTats.simple_remove_tattoo(npcs_ref[Slot], "DTTatsScars", "scars_whips"+i)	
			endif
			DTTools.log2("zadWhipsTat remove",i)
			i+=1
		endWhile
		DTTools.log2("zadWhipsTat add",count)
		if DTConfig.enableWhipsMarks == true
			SlaveTats.simple_add_tattoo(npcs_ref[Slot], "DTTatsScars", "scars_whips"+count)
		endif
		npcs_hitsZadTatStageLastKnow[Slot] = count
	endif
endFunction

function processHitsZad(int Slot, int totalHits)

	int diff = 0
		
	if npcs_lastKnownHitsZad[Slot] != totalHits
		diff = totalHits - npcs_lastKnownHitsZad[Slot]
	endIf
	DTTools.log2("zadWhips stage 1",diff)
	npcs_lastKnownHitsZad[Slot] = totalHits
	if diff == 0
		DTTools.log2(" HITS nothing to do",diff)
		return
	endif
	DTTools.log2(" HITS something to do",diff)
	diff = diff / 10
	if diff == 0
		diff = 1
	endif
	if diff > 2
		diff = 2
	endIf
	
	DTTools.log2("zadWhips stage 2",diff)
	
	int toAdd = utility.randomInt(-1*diff*4, diff)
	if toAdd > 0
		npcs_hitsZadTatStage[Slot] = npcs_hitsZadTatStage[Slot] + toAdd
		processHitsZadTats(Slot, npcs_hitsZadTatStage[Slot])
	endif
	
endFunction




function updateEyes(int Slot)



;DTConfig.blindfoldScaleEyes
float level =  npcs_ref[Slot].GetFactionRank(DTConfig.DT_Blindfold) as float

float value = (( 100 / 6 ) * level ) as float / 100

float mod = -1 * ( DTConfig.blindfoldScaleEyes as float / 10 ) as float * value


if mod > 0
			
			npcs_ref[Slot].SetExpressionModifier(0,  mod )
			npcs_ref[Slot].SetExpressionModifier(1,  mod )
		else
			
			mod = mod * -1.0
			npcs_ref[Slot].SetExpressionModifier(0,  0 )
			npcs_ref[Slot].SetExpressionModifier(1,  0 )
			npcs_ref[Slot].SetExpressionModifier(6,  mod )
			npcs_ref[Slot].SetExpressionModifier(7,  mod )
			npcs_ref[Slot].SetExpressionOverride(12, (mod * 100) as int)
		endif

endFunction

function updateMouth(int Slot)

	float level =  npcs_ref[Slot].GetFactionRank(DTConfig.DT_Gag) as float
	
	level = (( 100 / 6 ) * level ) as float	
	
	float value = ( DTConfig.gagScaleMouth as float )/ 100
	
	value = value * (level/100) 
	
			
	SetPhonemeModifier(npcs_ref[Slot], 0, 1,  (100.0 as float * value) as int)
	SetPhonemeModifier(npcs_ref[Slot], 0, 11, (70.0 as float * value ) as int)
	
	
endFunction

function updateBreasts(int Slot, int LevelChastityBra = 0)
	;is there something to do?
	if DTConfig.modSlif == false
		return
	endif

	;ok...
	bool breastNodesAreShowed = false
	if DTConfig.patchDDDeviousBra == true && npcs_ref[Slot].WornHasKeyword(libs.zad_DeviousBra)==true
		SLIF_Main.hideNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC L Breast", 0.1, "Devious Training Mayhem")	;0.1 - almost flat breasts
		SLIF_Main.hideNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC R Breast", 0.1, "Devious Training Mayhem")	;0.1 - almost flat breasts
		breastNodesAreShowed = false
		return	;no more to do
	else
		;we can show it always - becouse next block need it (take a look at breastNodesAreShowed bool)
		SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC L Breast")
		SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC R Breast")
		breastNodesAreShowed = true
	endif
	
	 if DTConfig.compressedBreasts == true

		if LevelChastityBra >= 1 && DTConfig.chastityBraScaleBreasts < 1

			;grab all keys

			if breastNodesAreShowed == false
				SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC L Breast")
				SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC R Breast")
			endif
			
			float breastSizeL = SLIF_Main.getValue(npcs_ref[Slot],"All Mods","NPC L Breast")
			float breastSizeR = SLIF_Main.getValue(npcs_ref[Slot],"All Mods","NPC R Breast")

			;formula is attached on github in excel file

			float levelFactor = (LevelChastityBra as float/6) as float
			float sliderFactor = (1- DTConfig.chastityBraScaleBreasts ) as float
			float totalFactor = (levelFactor * sliderFactor) as float

			breastSizeL = breastSizeL - ( breastSizeL *  totalFactor ) as float 
			breastSizeR = breastSizeR - ( breastSizeR *  totalFactor ) as float 

			SLIF_Main.hideNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC L Breast", breastSizeL, "Devious Training Mayhem")
			SLIF_Main.hideNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC R Breast", breastSizeR, "Devious Training Mayhem")
		else
			SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC L Breast")
			SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "NPC R Breast")
		endIf
	endif
endFunction

function updateCollar(int Slot, int Level = 0)
	
	bool dynamicScaleEnabled = true
	
	
	
	float neckFactor = DTConfig.collarScaleNeck as float
	
	;level 0 = (100/6) * 0 = 16.6 * 0 = 0
	;level 6 = (100/6) * 6 = 16.6 * 6 = 99.6
	
	float value = ( 100 / 6 ) * Level
		
	;max 1 100/100
	float reduction = value / 100
	
	
	reduction = reduction * (neckFactor as float/ 100) as float  ;max 0.5
	
	if dynamicScaleEnabled == true && npcs_ref[Slot].WornHasKeyword(libs.zad_DeviousCollar)==false
		reduction = reduction * 0.6
	endif
	
	;old calc		
	;float neck = 1 + (reduction * 1.5)
	;float head = 1 - reduction
	
	float neck = 1 + reduction
	float head = 1 / neck
	
	
	if DTConfig.modSlif == false
		if NiOverride.GetNodeTransformScale(npcs_ref[Slot],False,True,"NPC Head [Head]","Devious Training Mayhem") != head
			NiOverride.AddNodeTransformScale(npcs_ref[Slot],False,True,"NPC Neck [Neck]","Devious Training Mayhem", neck)
			NiOverride.AddNodeTransformScale(npcs_ref[Slot],False,True,"NPC Head [Head]","Devious Training Mayhem", head)
			NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Neck [Neck]") 
			NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Head [Head]") 
		endif
	else
		SLIF_Main.inflate(npcs_ref[Slot], "Devious Training Mayhem", "NPC Neck [Neck]", neck, -1, -1, "Devious Training Mayhem")
		SLIF_Main.inflate(npcs_ref[Slot], "Devious Training Mayhem", "NPC Head [Head]", head, -1, -1, "Devious Training Mayhem")
	endif
	
endFunction

function updateBelly(int Slot)
	;is there something to do?
	if DTConfig.modSlif == false
		return
	endif
	if DTConfig.patchDDDeviousCorset==true
		 if npcs_ref[Slot].WornHasKeyword(libs.zad_DeviousCorset)==true
			SLIF_Main.hideNode(npcs_ref[Slot], "Devious Training Mayhem", "slif_belly", 0.1, "DTT")	;0.1 - almost flat breasts
		 else
			SLIF_Main.showNode(npcs_ref[Slot], "Devious Training Mayhem", "slif_belly")
		 endif
	endif

endFunction

function updateWaist(int Slot, int LevelCorset = 0, int LevelHarness,  int LevelChastity = 0)
	bool dynamicScaleEnabled = true
	
	Int all = LevelCorset + LevelChastity + LevelHarness		
	float waistFactor = DTConfig.corsetScaleWaist as float + DTConfig.chastityBeltScaleWaist as float + DTConfig.harnessScaleWaist as float 
	
	if dynamicScaleEnabled == true
		float tempAll = 0
		waistFactor = 0
		if npcs_ref[Slot].WornHasKeyword(libs.zad_DeviousCorset)==false
			tempAll = tempAll + (LevelCorset * 0.6 ) as float
			waistFactor = waistFactor + ( DTConfig.corsetScaleWaist * 0.6 ) as float
		else
			tempAll = tempAll + (LevelCorset as float)
			waistFactor = waistFactor + DTConfig.corsetScaleWaist as float 
		endif
		
		if npcs_ref[Slot].WornHasKeyword(libs.zad_DeviousBelt)==false
			tempAll = tempAll + (LevelChastity * 0.6 ) as float
			waistFactor = waistFactor + ( DTConfig.chastityBeltScaleWaist * 0.6 ) as float
		else
			tempAll = tempAll + (LevelChastity as float)
			waistFactor = waistFactor + DTConfig.chastityBeltScaleWaist  as float 
		endif
		
		if npcs_ref[Slot].WornHasKeyword(libs.zad_DeviousHarness)==false
			tempAll = tempAll + (LevelHarness * 0.6 ) as float
			waistFactor = waistFactor + ( DTConfig.harnessScaleWaist * 0.6 ) as float 
		else
			tempAll = tempAll + (LevelHarness as float)
			waistFactor = waistFactor + DTConfig.harnessScaleWaist  as float 
		endif
		
		all = tempAll as int
	endif
	
		
	float value = ( 100 / 18 ) * all
	
	float reduction = value / 100
	
	reduction = reduction * (waistFactor as float/ 100) as float  ;max 0.5
	
		
	;float sp1 = 1 - reduction
	;float sp2 = 1 + (reduction * (1+ (waistFactor as float/ 100) ) * 1.4 )
	float sp1 = 1 - reduction
	float sp2 = 1/sp1
	
	

	if DTConfig.modSlif == false
		if NiOverride.GetNodeTransformScale(npcs_ref[Slot],False,True,"NPC Spine1 [Spn1]","Devious Training Mayhem") != (sp1)
			NiOverride.AddNodeTransformScale(npcs_ref[Slot],False,True,"NPC Spine1 [Spn1]","Devious Training Mayhem", sp1)
			NiOverride.AddNodeTransformScale(npcs_ref[Slot],False,True,"NPC Spine2 [Spn2]","Devious Training Mayhem", sp2)
			NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Spine1 [Spn1]") 
			NiOverride.UpdateNodeTransform(npcs_ref[Slot], false, True, "NPC Spine2 [Spn2]") 
		endif
	else
			SLIF_Main.inflate(npcs_ref[Slot], "Devious Training Mayhem", "NPC Spine1 [Spn1]", sp1, -1, -1, "Devious Training Mayhem")
			SLIF_Main.inflate(npcs_ref[Slot], "Devious Training Mayhem", "NPC Spine2 [Spn2]", sp2, -1, -1, "Devious Training Mayhem")
	endIf
endFunction









; OVERLAY BLOCK START

Function ActorOverlayCommit(Actor akActor)
		NiOverride.ApplyNodeOverrides(akActor)
endFunction

Function ActorOverlayRemove(Actor akActor, String bodyPart,String kind, Bool commit = true)


	String NodeName = ActorOverlayGetSlot(akActor,bodyPart,kind)
	if NodeName == ""
		return
	endif

	Bool NodeSex = (akActor.GetLeveledActorBase().GetSex() == 1)
	String textureName = "DTM.Overlay."+kind+"."+bodyPart

	NiOverride.RemoveAllNodeNameOverrides(akActor,NodeSex,NodeName)
	NiOverride.AddNodeOverrideString(akActor,NodeSex,NodeName,9,0,"textures\\Actors\\character\\overlays\\default.dds",TRUE)
	StorageUtil.UnsetStringValue(akActor,textureName)
	if commit == true
		NiOverride.ApplyNodeOverrides(akActor)
	endif

	Return
EndFunction

Function ActorOverlayAdd(Actor akActor, String bodyPart,String kind, String textureName, bool commit = true, float alpha = 1.0)
	String NodeName = ActorOverlayGetSlot(akActor,bodyPart,kind)
	if NodeName == ""
		return
	endif
	textureName = "textures\\Actors\\character\\slavetats\\devioustraining\\"+textureName+".dds"
	
	Bool NodeSex = (akActor.GetLeveledActorBase().GetSex() == 1)
	
	NiOverride.AddNodeOverrideString(akActor,NodeSex,NodeName,9, 0,textureName,TRUE)
	NiOverride.AddNodeOverrideFloat(akActor,NodeSex,NodeName,8,-1,alpha,TRUE)
	NiOverride.AddNodeOverrideInt(akActor,NodeSex,NodeName,7,-1,1, TRUE)
	;; NiOverride.AddNodeOverrideInt(Who,NodeSex,NodeName,0,-1,0,TRUE)
	;; NiOverride.AddNodeOverrideFloat(Who,NodeSex,NodeName,0,-1,1.0,TRUE)
	if commit == true
		NiOverride.ApplyNodeOverrides(akActor)
	endif
	
endFunction


String Function ActorOverlayGetSlot(Actor akActor, String bodyPart,String kind )
{find the next available overlay slot, or the slot we were already using.}

	String NodeName

	;; prefix the overlay name.

	String textureName = "DTM.Overlay."+kind+"."+bodyPart

	;; see if we already selected a node.

	NodeName = StorageUtil.GetStringValue(akActor,textureName)
	If(NodeName != "")
		Return NodeName
	EndIf

	;; alright lets find an empty slot and gank it.

	;int Function GetNumBodyOverlays() native global
	;int Function GetNumHandOverlays() native global
	;int Function GetNumFeetOverlays() native global
	;int Function GetNumFaceOverlays() native global
	
	
	Int NodeCount = 0;
	String PartName = "";
	if bodyPart == "body"
		NodeCount = NiOverride.GetNumBodyOverlays()
		PartName = "Body"
	endif
	
	if bodyPart == "hand"
		NodeCount = NiOverride.GetNumHandOverlays()
		PartName = "Hands"
	endif
	
	if bodyPart == "feet"
		NodeCount = NiOverride.GetNumFeetOverlays()
		PartName = "Feet"
	endif

	if bodyPart == "face"
		NodeCount = NiOverride.GetNumFaceOverlays()
		PartName = "Face"
	endif
	
	
	Int NodeIter = 0
	Bool NodeSex = (akActor.GetLeveledActorBase().GetSex() == 1)
	String NodeTexture

	While(NodeIter < NodeCount)
		NodeName = PartName+" [Ovl" + NodeIter + "]"
		NodeTexture = NiOverride.GetNodeOverrideString(akActor,NodeSex,NodeName,9,0)

		If(NodeTexture == "" || NodeTexture == "textures\\Actors\\character\\overlays\\default.dds")
			;; mine now.
			StorageUtil.SetStringValue(akActor,textureName,NodeName)

			Return NodeName
		EndIf

		NodeIter += 1
	EndWhile

	Return ""
EndFunction

; OVERLAY BLOCK STOP
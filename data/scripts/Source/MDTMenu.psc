Scriptname MDTMenu extends SKI_ConfigBase

DTMConfig Property DTConfig Auto
DTMTools Property DTTools Auto
DTMActor Property DTActor Auto
DTMMain Property DTMain Auto

int generalEnabled

Event OnGameReload()
	parent.OnGameReload()
	Return
EndEvent

Event OnVersionUpdate(Int ver)
	OnConfigInit()
	Return
EndEvent

Int Function GetVersion()
  OnConfigInit()
  Return (DTMain.getVersion()*100) as int
EndFunction




Event OnConfigClose()
	DTMain.onLoadFunction()
	DTMain.updateActors()
endEvent

Event OnConfigInit()

	generalEnabled = 0
	
	if DTConfig.modEnabled == true
		generalEnabled  = 1
	endif
	
	if DTConfig.lastVersion == 0
		generalEnabled  = 0
	endif

	
	if DTConfig.mcmWorking==true		
		generalEnabled  = 0
	endIf
	
	ModName = "Devious Training Mayhem"
	
	Pages = new String[2]
	Pages[0] = "Items effects"
	Pages[1] = "Activity effects"
	
	Return
EndEvent



Event OnPageReset(string page)
	
	
	
	OnConfigInit()
	SetCursorFillMode(TOP_TO_BOTTOM)
		
	;DTMain.turnOffMod()
	
	
  
	if DTConfig.mcmWorking == true
		debug.messagebox("Please wait\nMod still working to apply your latest changes. \nClose MCM and wait a moment...\n\nIf its Your first run:\nmake sure that you uninstalled old version of this mod [1.x].")
	endif
	
	if (page == "")
	
		LoadCustomContent("DeviousTraining/DT.dds", 176, 23)
		return
	else
		UnloadCustomContent()
	endIf
  
	int mcmWorkInt = 1;
	if DTConfig.mcmWorking == true
		mcmWorkInt = 0
	endif
	

    
	if (page == "Items effects" || page == "")
		SetTitleText("General settings, version:"+DTMain.getDisplayVersion())
		
		AddHeaderOption("Waist ")
		corsetScaleWaist = AddSliderOption("Corset scale",DTConfig.corsetScaleWaist,"{0}")
		chastityBeltScaleWaist = AddSliderOption("Chastity belt scale",DTConfig.chastityBeltScaleWaist,"{0}")
		harnessScaleWaist = AddSliderOption("Harness scale",DTConfig.harnessScaleWaist,"{0}")
		
		AddEmptyOption()   
		
		AddHeaderOption("Neck ")
		collarScaleNeck = AddSliderOption("Collar scale",DTConfig.collarScaleNeck,"{0}")
		
		AddEmptyOption()   
		
		AddHeaderOption("Breasts ")
		
		chastityBraScaleBreasts = AddSliderOption("Chastity Bra scale",DTConfig.chastityBraScaleBreasts,"{1}")
		
		SetCursorPosition(1)	
		
		AddHeaderOption("Eyes ")
		
		blindfoldScaleEyes = AddSliderOption("Blindfold eyes scale",DTConfig.blindfoldScaleEyes,"{0}")
		AddHeaderOption("Mouth ")
		gagScaleMouth = AddSliderOption("Gag mouth scale",DTConfig.gagScaleMouth,"{0}")
		
		AddEmptyOption()   
		AddHeaderOption("Plugs ")
		analPlugEffect = AddToggleOption("Ruined anus",DTConfig.analPlugEffect)		
		vaginalPlugEffect = AddToggleOption("Ruined vagina",DTConfig.vaginalPlugEffect)		
	endif
	
	if (page == "Activity effects")
		allowItemoverlays  = AddToggleOption("Enable item marks",DTConfig.allowItemoverlays)
		enableWhipsMarks  = AddToggleOption("Enable whips marks",DTConfig.enableWhipsMarks)
	endif
endEvent

Event OnOptionSelect(Int Menu)
	
	
	if Menu == supportSteps
		if  DTConfig.supportSteps == true
			DTConfig.supportSteps = false
		else			
			DTConfig.supportSteps = true							
		endIf
		SetToggleOptionValue(Menu,  DTConfig.supportSteps)		
		return
	endIf		
	if Menu == analPlugEffect
		if  DTConfig.analPlugEffect == true
			DTConfig.analPlugEffect = false
		else			
			DTConfig.analPlugEffect = true							
		endIf
		SetToggleOptionValue(Menu,  DTConfig.analPlugEffect)		
		return
	endIf		
	if Menu == vaginalPlugEffect
		if  DTConfig.vaginalPlugEffect == true
			DTConfig.vaginalPlugEffect = false
		else			
			DTConfig.vaginalPlugEffect = true							
		endIf
		SetToggleOptionValue(Menu,  DTConfig.vaginalPlugEffect)		
		return
	endIf	
			
	
	if Menu == enableWhipsMarks
		if  DTConfig.enableWhipsMarks == true
			DTConfig.enableWhipsMarks = false
		else			
			DTConfig.enableWhipsMarks = true							
		endIf
		SetToggleOptionValue(Menu,  DTConfig.enableWhipsMarks)		
		return
	endIf	
	
	
	if Menu == allowItemoverlays
		if  DTConfig.allowItemoverlays == true
			DTConfig.allowItemoverlays = false
		else			
			DTConfig.allowItemoverlays = true							
		endIf
		SetToggleOptionValue(Menu,  DTConfig.allowItemoverlays)		
		return
	endIf	
	
	
	
	
	
endEvent

Event OnOptionSliderAccept(Int Menu, Float Val)
	if Menu == corsetScaleWaist
		DTConfig.corsetScaleWaist = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")	
		updateActors()
	endif		
	if Menu == harnessScaleWaist
		DTConfig.harnessScaleWaist = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")	
		updateActors()
	endif		
	if Menu == chastityBeltScaleWaist
		DTConfig.chastityBeltScaleWaist = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")	
		updateActors()
	endif		
	if Menu == collarScaleNeck
		DTConfig.collarScaleNeck = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")	
		updateActors()
	endif		
	if Menu == chastityBraScaleBreasts
		DTConfig.chastityBraScaleBreasts = Val as float
		SetSliderOptionValue(Menu,Val,"{1}")	
		updateActors()
	endif			
	if Menu == gagScaleMouth
		DTConfig.gagScaleMouth = Val as Int
		SetSliderOptionValue(Menu,Val,"{1}")	
		updateActors()
	endif		
	if Menu == blindfoldScaleEyes
		DTConfig.blindfoldScaleEyes = Val as Int
		SetSliderOptionValue(Menu,Val,"{0}")	
		updateActors()
	endif			
	
	
endEvent	



function sliderSetupOpenInt(Int Menu, Int IntName,Int ConfValue, int rangeStart = 0, int rangeStop = 100, int interval = 1)
	if (Menu == IntName)
		SetSliderDialogStartValue(ConfValue)
		SetSliderDialogRange(rangeStart,rangeStop)
		SetSliderDialogInterval(interval)
	endIf
endFunction

function sliderSetupOpenFloat(Int Menu, Int IntName,Float ConfValue, float rangeStart = 0.0, float rangeStop = 100.0, float interval = 0.1)
	if (Menu == IntName)
		SetSliderDialogStartValue(ConfValue)
		SetSliderDialogRange(rangeStart,rangeStop)
		SetSliderDialogInterval(interval)
	endIf
endFunction

Event OnOptionSliderOpen(Int Menu)
	sliderSetupOpenInt(Menu,corsetScaleWaist,DTConfig.corsetScaleWaist,0,85,1);
	sliderSetupOpenInt(Menu,harnessScaleWaist,DTConfig.harnessScaleWaist,0,20,1);
	sliderSetupOpenInt(Menu,chastityBeltScaleWaist,DTConfig.chastityBeltScaleWaist,0,25,1);
	
	sliderSetupOpenInt(Menu,collarScaleNeck,DTConfig.collarScaleNeck,0,45,1);
	sliderSetupOpenInt(Menu,blindfoldScaleEyes,DTConfig.blindfoldScaleEyes,-10,10,1);
	sliderSetupOpenInt(Menu,gagScaleMouth,DTConfig.gagScaleMouth,0,150,1);

	
	sliderSetupOpenFloat(Menu,chastityBraScaleBreasts,DTConfig.chastityBraScaleBreasts,0.1,1,0.1);
	
endEvent

function updateActors()
	;DTMain.updateActors()
endFunction

int function getEnableFlag(int in)

	if in == 1
		return OPTION_FLAG_NONE
	endif
	
	return OPTION_FLAG_DISABLED
endFunction

int gagScaleMouth
int corsetScaleWaist
int harnessScaleWaist
int chastityBeltScaleWaist
int collarScaleNeck
int chastityBraScaleBreasts
int blindfoldScaleEyes

int bodyWithoutSexBreasts
int bodyWithoutSexButt
int bodyWithoutSexBelly

int allowItemoverlays

int minOrgasmCount
int bodyScaleFactor
int bodyWithoutSexGrowth
int supportOrgasm
int supportSteps
int enableBodyWeight
int bodyScaleFatThigh
int enableWhipsMarks

int vaginalPlugEffect
int analPlugEffect
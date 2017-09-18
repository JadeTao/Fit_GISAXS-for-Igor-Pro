#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function askLAYERparameters()
	DoWindow/K Layer_parameters
	String cmd,titletemp
	Wave/D nps,thickness,delta,betta
	Wave/T textWave1
	NVAR slayer,deltaLAY,betaLAY

	If (cmpstr(textWave1[3],"Born approximation")==0)
	
	ElseIf (cmpstr(textWave1[3],"Supported islands")==0)
		slayer=0
		nps=0
	Else
		If (numpnts(nps)==1)
			InsertPoints 0,1, delta,betta,thickness,roughness,nps
			delta[0]=delta[1]
			betta[0]=betta[1]
		Endif
		If (slayer==0)
			slayer=1
			nps[0]=1
		Endif
		If (cmpstr(textWave1[2], "Paracrystal 3D")==0)
			nps=0
			slayer=1
			nps[0]=1
		Endif
	Endif
	
	thickness[numpnts(nps)-1]=inf
	
	If (slayer==0)
		deltaLAY=0
		betaLAY=0
	Else
		deltaLAY=delta[slayer-1]
		betaLAY=betta[slayer-1]	
	Endif

	NewPanel/M/W=(0.2, 1.6, 16.2, min(18.8,3.1+0.9*numpnts(nps)))/N=Layer_parameters	//W=(left, top, right, bottom )
	ModifyPanel/W=Layer_parameters cbRGB=(65280,65280,48896), frameInset= 3, frameStyle= 1

	TitleBox title1 title="      \\F'Symbol'd      ",frame=4,fSize=13,labelBack=(60928,60928,60928),pos={110,8}
	TitleBox title2 title="      \\F'Symbol'b      ",frame=4,fSize=13,labelBack=(60928,60928,60928),pos={210,8}
	TitleBox title3 title="Thickness",frame=4,fSize=13,labelBack=(60928,60928,60928),pos={305,8}
	TitleBox title4 title="Roughness",frame=4,fSize=13,labelBack=(60928,60928,60928),pos={400,8}
	DrawText 325,50,"(nm)"
	DrawText 425,50,"(nm)"

	cmd="CheckBox check0 title=\"\",pos={492,15},mode=1,value="+num2str(1-sum(nps))+",proc=CheckBoxProc"
	Execute cmd
	
	Button button0 title="New table",size={70,20},pos={525,8},fSize=10,proc=ProcNewLayerParameters
	Button button1 title="Insert layer",size={70,20},pos={525,62},fSize=10,proc=ProcInsertLayerParameters
	Button button2 title="Delete layer",size={70,20},pos={525,90},fSize=10,proc=ProcDeleteLayerParameters
	Button button3 title="Display table",size={70,20},pos={525,34},fSize=10,proc=ProcDisplayLayerParameters

	Variable i=0
	For (i=0;i<numpnts(thickness)-1;i+=1)
		titletemp="\" Layer #"+num2str(i+1)+" \""
		cmd="TitleBox title"+num2str(i+5)+" title="+titletemp+",frame=4,fSize=13,labelBack=(60928,60928,60928),pos={20,"+num2str(50+30*i)+"}"
		Execute cmd
		titletemp="\" \""
		cmd="SetVariable setvar"+num2str(i+1)+" title="+titletemp+",pos={110,"+num2str(55+30*i)+"},size={60,20},value=delta["+num2str(i)+"],limits={0,inf,0},proc=updateLAY"
		Execute cmd
		titletemp="\" \""
		cmd="SetVariable setvar"+num2str(i+101)+" title="+titletemp+",pos={210,"+num2str(55+30*i)+"},size={60,20},value=betta["+num2str(i)+"],limits={0,inf,0},proc=updateLAY"
		Execute cmd
		titletemp="\" \""
		cmd="SetVariable setvar"+num2str(i+201)+" title="+titletemp+",pos={310,"+num2str(55+30*i)+"},size={60,20},value=thickness["+num2str(i)+"],limits={0,inf,0}"
		Execute cmd
		titletemp="\" \""
		cmd="SetVariable setvar"+num2str(i+301)+" title="+titletemp+",pos={410,"+num2str(55+30*i)+"},size={60,20},value=roughness["+num2str(i)+"],limits={0,inf,0}"
		Execute cmd
		
		cmd="CheckBox check"+num2str(i+1)+" title=\"\",pos={492,"+num2str(55+30*i)+"},mode=1,value=nps["+num2str(i)+"],proc=CheckBoxProc"
		Execute cmd

		If (nps[i]==1)
			cmd="TitleBox title"+num2str(i+5)+" labelBack=(39680,59392,38656)"
			Execute cmd
			cmd="SetVariable setvar"+num2str(i+1)+" frame=0,  labelBack=(39680,59392,38656)"
			Execute cmd
			cmd="SetVariable setvar"+num2str(i+101)+" frame=0,  labelBack=(39680,59392,38656)"
			Execute cmd
			cmd="SetVariable setvar"+num2str(i+201)+" frame=0,  labelBack=(39680,59392,38656)"
			Execute cmd
			cmd="SetVariable setvar"+num2str(i+301)+" frame=0,  labelBack=(39680,59392,38656)"
			Execute cmd
		Endif
	Endfor
	titletemp="\" Substrate \""
	cmd="TitleBox title"+num2str(i+5)+" title="+titletemp+",frame=4,fSize=13,labelBack=(52224,52224,52224),pos={20,"+num2str(50+30*i)+"}"
	Execute cmd
	titletemp="\" \""
	cmd="SetVariable setvar"+num2str(i+1)+" title="+titletemp+",pos={110,"+num2str(55+30*i)+"},size={60,20},value=delta["+num2str(i)+"],limits={0,inf,0}"
	Execute cmd
	titletemp="\" \""
	cmd="SetVariable setvar"+num2str(i+101)+" title="+titletemp+",pos={210,"+num2str(55+30*i)+"},size={60,20},value=betta["+num2str(i)+"],limits={0,inf,0}"
	Execute cmd
	titletemp="\" \""
	cmd="SetVariable setvar"+num2str(i+201)+" title="+titletemp+",pos={310,"+num2str(55+30*i)+"},size={60,20},value=thickness["+num2str(i)+"],limits={0,inf,0}"
	Execute cmd
	titletemp="\" \""
	cmd="SetVariable setvar"+num2str(i+301)+" title="+titletemp+",pos={410,"+num2str(55+30*i)+"},size={60,20},value=roughness["+num2str(i)+"],limits={0,inf,0}"
	Execute cmd
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function CheckBoxProc (ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if selected, 0 if not
	Wave nps
	NVAR slayer
	String cmd
	
	nps=0
	Variable i=str2num(ctrlName[5,strlen(ctrlName)])
	If (i==0)
		slayer=0
		askLAYERparameters()
	Else
		nps[i-1]=1
		slayer=i
		askLAYERparameters()
	Endif
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ProcNewLayerParameters(ctrlName) : ButtonControl
	String ctrlName
	Variable numb_layer=1
	NVAR slayer
	
	slayer=0

	Prompt numb_layer,"Number of layers (including substrate):"
	DoPrompt "Enter layer parameters", numb_layer

	Make/O/D/N=(numb_layer) delta,betta,thickness,roughness,nps
	
	askLAYERparameters()
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ProcInsertLayerParameters(ctrlName) : ButtonControl
	String ctrlName
	Variable numb_layer,delta_layer,beta_layer,thickness_layer,roughness_layer
	NVAR slayer
	Wave/D delta,betta,thickness,roughness,nps
	numb_layer=1
	
	Prompt numb_layer,"Insert new layer before layer #:"
	Prompt delta_layer,"Layer delta:"
	Prompt beta_layer,"Layer beta:"
	Prompt thickness_layer,"Layer thickness (nm):"
	Prompt roughness_layer,"Layer roughness (nm):"
	DoPrompt "Enter layer parameters", numb_layer,delta_layer,beta_layer,thickness_layer,roughness_layer

	InsertPoints numb_layer-1,1, delta,betta,thickness,roughness,nps
	delta[numb_layer-1]=delta_layer
	betta[numb_layer-1]=beta_layer
	thickness[numb_layer-1]=thickness_layer
	roughness[numb_layer-1]=roughness_layer
	nps=0
	slayer=0
	
	askLAYERparameters()
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ProcDeleteLayerParameters(ctrlName) : ButtonControl
	String ctrlName
	Variable numb_layer,delta_layer,beta_layer,thickness_layer,roughness_layer
	NVAR slayer
	Wave/D delta,betta,thickness,roughness,nps
	numb_layer=1
	
	Prompt numb_layer,"Delete layer #:"
	DoPrompt "Enter layer parameters", numb_layer

	DeletePoints numb_layer-1,1, delta,betta,thickness,roughness,nps
	nps=0
	slayer=0

	askLAYERparameters()
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ProcDisplayLayerParameters(ctrlName) : ButtonControl
	String ctrlName
	DoWindow/K Table_Layer_parameters
	Edit/M/W=(0.2, 8, 16.2, 13.5) delta,betta,thickness,roughness,nps
	DoWindow/C Table_Layer_parameters
	ModifyTable width(delta)=72,width(betta)=72,width(thickness)=72,width(roughness)=72,width(nps)=72
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function updateLAY(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva
	NVAR slayer,deltaLAY,betaLAY
	Wave/D delta,betta

	If (slayer==0)
		deltaLAY=0
		betaLAY=0
	Else
		deltaLAY=delta[slayer-1]
		betaLAY=betta[slayer-1]	
	Endif
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

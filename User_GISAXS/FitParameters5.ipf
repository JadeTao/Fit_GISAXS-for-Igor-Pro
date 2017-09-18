#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function askFITparameters()
	Wave/T textWave0,textWave1
	String titletemp,setvar,cmd
	NVAR long_onde,deltaNPs,betaNPs,deltaNPc,betaNPc
	Variable i=0
	DoWindow/K Fit_parameters
	NewPanel/M/W=(16.6, 9.0, 26.3, 18.1)/N=Fit_parameters	//W=(left, top, right, bottom )
	ModifyPanel/W=Fit_parameters cbRGB=(65280,65280,48896)

	TabControl foo,pos={3,3},size={362,339},tabLabel(0)="Fitting parameters",value= 0
	TabControl foo labelBack=(65280,65280,48896)
	
	For (i=0;i<numpnts(coef);i+=2)
		titletemp=textwave0[i]
		setvar="setvar"+num2str(i)
		SetVariable $setvar title=titletemp,pos={20,30+35*i/2},size={150,20},value=coef[i],fSize=13,limits={-Inf,Inf,0},bodyWidth=60,disable=0
		If (cmpstr(textWave0[i], "None")==0)
			cmd="SetVariable "+setvar+" disable=1"
			Execute cmd
		Endif
	Endfor

	For (i=1;i<numpnts(coef);i+=2)
		titletemp=textwave0[i]
		setvar="setvar"+num2str(i)
		SetVariable $setvar title=titletemp,pos={205,30+35*(i-1)/2},size={150,20},value=coef[i],fSize=13,limits={-Inf,Inf,0},bodyWidth=60,disable=0
		If (cmpstr(textWave0[i], "None")==0)
			cmd="SetVariable "+setvar+" disable=1"
			Execute cmd
		Endif
	Endfor
	i-=1

	TabControl foo,proc=fooProc,tabLabel(1)="More parameters"

	cmd="ValDisplay valdisp0 title=\"Wavelength (nm)\",value=long_onde,size={180,17},fSize=12,pos={20,30},fstyle=1,disable=1"
	Execute cmd
	cmd="ValDisplay valdisp1 title=\"Energy (eV)\",value=1239.97/long_onde,size={135,17},fSize=12,pos={220,30},fstyle=1,disable=1"
	Execute cmd
	setvar="setvar"+num2str(i)
	SetVariable $setvar title=" Incidence angle (deg)",pos={20,65},size={190,20},value=alphai_detec,fsize=14,limits={0,90,0.005},bodyWidth=60,disable=1,frame=1,proc=SetVarProcAlphai
	setvar="setvar"+num2str(i+1)
	SetVariable $setvar title=" Azimuthal angle (deg)",pos={20,100},size={190,20},value=phi_detec,fsize=14,limits={0,360,5},bodyWidth=60,disable=1,frame=1
	setvar="setvar"+num2str(i+2)
	SetVariable $setvar title=" Tilt angle (deg)",pos={20,135},size={190,20},value=psi_detec,fsize=14,limits={-90,90,5},bodyWidth=60,disable=1,frame=1
	If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0 || cmpstr(textWave1[4], "Core-shell ripple")==0)
		setvar="setvar"+num2str(i+3)
		SetVariable $setvar title=" \\F'Symbol'd\\F'Arial' core",pos={20,170},size={190,20},value=deltaNPs,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
		setvar="setvar"+num2str(i+4)
		SetVariable $setvar title=" \\F'Symbol'b\\F'Arial' core",pos={20,205},size={190,20},value=betaNPs,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
		setvar="setvar"+num2str(i+5)
		SetVariable $setvar title=" \\F'Symbol'd\\F'Arial' shell",pos={20,240},size={190,20},value=deltaNPc,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
		setvar="setvar"+num2str(i+6)
		SetVariable $setvar title=" \\F'Symbol'b\\F'Arial' shell",pos={20,275},size={190,20},value=betaNPc,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
	Else
		setvar="setvar"+num2str(i+3)
		SetVariable $setvar title=" \\F'Symbol'd\\F'Arial' scatterers",pos={20,170},size={190,20},value=deltaNPs,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
		setvar="setvar"+num2str(i+4)
		SetVariable $setvar title=" \\F'Symbol'b\\F'Arial' scatterers",pos={20,205},size={190,20},value=betaNPs,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
		setvar="setvar"+num2str(i+5)
		SetVariable $setvar title=" \\F'Symbol'd\\F'Arial' shell",pos={20,240},size={190,20},value=deltaNPc,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
		setvar="setvar"+num2str(i+6)
		SetVariable $setvar title=" \\F'Symbol'b\\F'Arial' shell",pos={20,275},size={190,20},value=betaNPc,fsize=14,bodyWidth=70,disable=1,frame=1,limits={0,1,0}
	Endif
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function fooProc(name,tab)
	String name
	Variable tab
	String titletemp,setvar,cmd
	Variable i
	Wave/T textWave0,textWave1
	
	If (tab==0)
		For (i=0;i<numpnts(coef);i+=1)
			setvar="setvar"+num2str(i)
			If (cmpstr(textWave0[i], "None")!=0)
				cmd="SetVariable "+setvar+" disable=0"
				Execute cmd
			Endif
		Endfor
		For (i=numpnts(coef);i<numpnts(coef)+7;i+=1)
			setvar="setvar"+num2str(i)
			cmd="SetVariable "+setvar+" disable=1"
			Execute cmd
		Endfor
		ValDisplay valdisp0 disable=1
		ValDisplay valdisp1 disable=1
	Else
		For (i=0;i<numpnts(coef);i+=1)
			setvar="setvar"+num2str(i)
			cmd="SetVariable/Z "+setvar+" disable=1"
			Execute cmd
		Endfor
		For (i=numpnts(coef);i<numpnts(coef)+5;i+=1)
			setvar="setvar"+num2str(i)
			cmd="SetVariable "+setvar+" disable=0"
			Execute cmd
		Endfor
		If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell ripple")==0)
			For (i=numpnts(coef)+5;i<numpnts(coef)+7;i+=1)
				setvar="setvar"+num2str(i)
				cmd="SetVariable "+setvar+" disable=0"
				Execute cmd
			Endfor
		Endif
		ValDisplay valdisp0 disable=0
		ValDisplay valdisp1 disable=0
	Endif
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function SetVarProcAlphai(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR DirectY,alphai_detec,distance,resolutionY,long_onde
	Wave/D alphaf,alphaf_detec,wavetwothetaf,wavealphaf,wavevector_x,wavevector_y,wavevector_z
	
	DoWindow/K cut2d
	DoWindow/K Fit2d_parameters
	DoWindow/K Guinier_plot
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	
	If (stringmatch(WinList("*",";",""), "*NewGISAXS*")==1)
		alphaf_detec=atan((p-(DirectY+tan(alphai_detec*pi/180)*distance/resolutionY))*resolutionY/distance)*180/pi
		alphaf=atan((p-(DirectY+tan(alphai_detec*pi/180)*distance/resolutionY))*resolutionY/distance)*180/pi
		ControlInfo/W=NewGISAXS button8
		If (V_disable==1)
			alphaf=2*pi/long_onde*(sin(alphaf*pi/180)+sin(alphai_detec*pi/180))
		Endif
	Endif
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------


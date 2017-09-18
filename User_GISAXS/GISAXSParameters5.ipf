#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function askGISAXSparameters()
	Wave/T textWave1
	NVAR long_onde,Dmin,Dmax
	SVAR MAstring
	Variable mode0,mode1,mode2,mode3,mode4,mode5

	If (cmpstr(textWave1[4], "Spheroid")==0)
		mode0=1
	ElseIf (cmpstr(textWave1[4], "Random spheroid")==0)
		mode0=2
	ElseIf (cmpstr(textWave1[4], "Ellipsoid")==0)
		mode0=3
	ElseIf (cmpstr(textWave1[4], "Cylinder")==0)
		mode0=4
	ElseIf (cmpstr(textWave1[4], "Hemispheroid")==0)
		mode0=5
	ElseIf (cmpstr(textWave1[4], "Truncated sphere")==0)
		mode0=6
	ElseIf (cmpstr(textWave1[4], "Facetted sphere")==0)
		mode0=7
	ElseIf (cmpstr(textWave1[4], "Capsule")==0)
		mode0=8
	ElseIf (cmpstr(textWave1[4], "Prism")==0)
		mode0=9
	ElseIf (cmpstr(textWave1[4], "Truncated tetrahedron")==0)
		mode0=10
	ElseIf (cmpstr(textWave1[4], "Ripple1")==0)
		mode0=11
	ElseIf (cmpstr(textWave1[4], "Ripple2")==0)
		mode0=12
	ElseIf (cmpstr(textWave1[4], "Anisotropic pyramid")==0)
		mode0=13
	ElseIf (cmpstr(textWave1[4], "Core-shell spheroid")==0)
		mode0=14
	ElseIf (cmpstr(textWave1[4], "Core-shell cylinder")==0)
		mode0=15
	ElseIf (cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
		mode0=16
	ElseIf (cmpstr(textWave1[4], "Core-shell ripple")==0)
		mode0=17
	EndIf	
	
	If (cmpstr(textWave1[2], "Random organization")==0)
		mode1=1
	ElseIf (cmpstr(textWave1[2], "Percus-Yevick 3D")==0)
		mode1=2
	ElseIf (cmpstr(textWave1[2], "Percus-Yevick 2D")==0)
		mode1=3
	ElseIf (cmpstr(textWave1[2], "Paracrystal 1D")==0)
		mode1=4
	ElseIf (cmpstr(textWave1[2], "Paracrystal 2D-rec")==0)
		mode1=5
	ElseIf (cmpstr(textWave1[2], "Paracrystal 2D-hex")==0)
		mode1=6
//	ElseIf (cmpstr(textWave1[2], "Paracrystal 3D")==0)
//		mode1=7
	EndIf	

	If (cmpstr(textWave1[6], "Monodisperse approximation")==0)
		mode2=1
	ElseIf (cmpstr(textWave1[6], "Local monodisperse approximation")==0)
		mode2=2
	ElseIf (cmpstr(textWave1[6], "Decoupling approximation")==0)
		mode2=3
	EndIf	

	If (cmpstr(textWave1[5], "Gaussian")==0)
		mode3=1
	ElseIf (cmpstr(textWave1[5], "DoubleGaussian")==0)
		mode3=2
	ElseIf (cmpstr(textWave1[5], "Log-normal")==0)
		mode3=3
	ElseIf (cmpstr(textWave1[5], "DoubleLog-normal")==0)
		mode3=4
	ElseIf (cmpstr(textWave1[5], "Weibull")==0)
		mode3=5
	EndIf	

	If (cmpstr(textWave1[3], "Born approximation")==0)
		mode4=1
	ElseIf (cmpstr(textWave1[3], "Supported islands")==0)
		mode4=2
	ElseIf (cmpstr(textWave1[3], "Sandwiched islands")==0)
		mode4=3
	ElseIf (cmpstr(textWave1[3], "Sandwiched layer")==0)
		mode4=4
	ElseIf (cmpstr(textWave1[3], "Buried layer")==0)
		mode4=5
	ElseIf (cmpstr(textWave1[3], "Correlated roughness")==0)
		mode4=6
	ElseIf (cmpstr(textWave1[3], "Surface holes")==0)
		mode4=7
	EndIf	

	If (cmpstr(textWave1[7], "Constant")==0)
		mode5=1
	ElseIf (cmpstr(textWave1[7], "Polynomial")==0)
		mode5=2
//	ElseIf (cmpstr(textWave1[7], "Bell")==0)
//		mode5=3
	EndIf	
	
	DoWindow/K GISAXS_parameters
	NewPanel/M/W=(16.6, 1.6, 26.3, 8.0)/N=GISAXS_parameters	//W=(left, top, right, bottom )
	ModifyPanel/W=GISAXS_parameters cbRGB=(65280,65280,48896), frameInset= 3, frameStyle= 1
	PopupMenu popup4,pos={10,10},fsize=13,size={100,20},proc=PopMenuProc4,title="Layer geometry:",value="Born approximation;Supported islands;Sandwiched islands;Sandwiched layer;Buried layer;Correlated roughness;Surface holes",mode=mode4
	PopupMenu popup0,pos={10,50},fsize=13,size={100,20},proc=PopMenuProc0,title="Form factor:",value="Spheroid;Random spheroid;Ellipsoid;Cylinder;Hemispheroid;Truncated sphere;Facetted sphere;Capsule;Prism;Truncated tetrahedron;Ripple1;Ripple2;Anisotropic pyramid;Core-shell spheroid;Core-shell cylinder;Core-shell hemispheroid;Core-shell ripple",mode=mode0
//	PopupMenu popup1,pos={10,90},fsize=13,size={100,20},proc=PopMenuProc1,title="Structure factor:",value="Random organization;Percus-Yevick 3D;Percus-Yevick 2D;Paracrystal 1D;Paracrystal 2D-rec;Paracrystal 2D-hex;Paracrystal 3D",mode=mode1
	PopupMenu popup1,pos={10,90},fsize=13,size={100,20},proc=PopMenuProc1,title="Structure factor:",value="Random organization;Percus-Yevick 3D;Percus-Yevick 2D;Paracrystal 1D;Paracrystal 2D-rec;Paracrystal 2D-hex",mode=mode1
	PopupMenu popup2,pos={10,130},fsize=13,size={100,20},proc=PopMenuProc2,title="Size distribution model:",value="Monodisperse approximation;Local monodisperse approximation;Decoupling approximation",mode=mode2
	PopupMenu popup3,pos={10,170},fsize=13,size={100,20},proc=PopMenuProc3,title="Distribution function:",value="Gaussian;DoubleGaussian;Log-normal;DoubleLog-normal;Weibull",mode=mode3
//	PopupMenu popup5,pos={235,50},fsize=13,size={100,20},proc=PopMenuProc5,title="H/D\\By\\M:",value="Constant;Polynomial;Bell",mode=mode5
	PopupMenu popup5,pos={235,50},fsize=13,size={100,20},proc=PopMenuProc5,title="H/D:",value="Constant;Polynomial",mode=mode5
	SetVariable setvar6,pos={50,210},fsize=13,size={100,20},title="D min. (nm)",value=Dmin,limits={1e-6,Inf,1},bodyWidth=60,proc=SetVarProcDminDmax
	SetVariable setvar5,pos={200,210},fsize=13,size={100,20},title="D max. (nm)",value=Dmax,limits={1e-6,Inf,1},bodyWidth=60,proc=SetVarProcDminDmax

	If (cmpstr(textWave1[6], "Monodisperse Approximation")==0)
		PopupMenu popup3 disable=2
		PopupMenu popup5 disable=2
		SetVariable setvar5 disable=2
		SetVariable setvar6 disable=2
		MAstring="("	
	Else
		PopupMenu popup3 disable=0
		PopupMenu popup5 disable=0
		SetVariable setvar5 disable=0
		SetVariable setvar6 disable=0		
		MAstring=""	
	Endif

End

//----------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc0(ctrlName,popNum,popStr) : PopupMenuControl		// Form factor
	String ctrlName
	Variable popNum
	String popStr
	Wave/T textWave0,textWave1
	Wave/D coef
	Execute/P/Q/Z "DELETEINCLUDE  \"Form_"+textWave1[4]+"\""
	textwave1[4]=popstr
	Execute/P/Q/Z "INSERTINCLUDE  \"Form_"+textWave1[4]+"\""
	Execute/P/Q/Z "COMPILEPROCEDURES "
	
	If (cmpstr(textWave1[4], "Ripple1")==0)
		textwave0[2]="D\\By\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H/D\\By\\M (C\\B2\\M)"
		Endif
		textwave0[8]="None"
		textwave0[14]="D\\Bx\\M (nm)"
		textwave0[15]="None"
		coef[8]=-1
		coef[14]=coef[2]
		coef[15]=-1
	Elseif (cmpstr(textWave1[4], "Ripple2")==0 || cmpstr(textWave1[4], "Anisotropic pyramid")==0)
		textwave0[2]="D\\By\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H/D\\By\\M (C\\B2\\M)"
		Endif
		textwave0[8]="None"
		textwave0[14]="D\\Bx\\M (nm)"
		textwave0[15]="Asymmetry"
		coef[8]=-1
		coef[14]=coef[2]
		coef[15]=0
	ElseIf (cmpstr(textWave1[4], "Ellipsoid")==0)
		textwave0[2]="D\\By\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H/D\\By\\M (C\\B2\\M)"
		Endif
		textwave0[8]="None"
		textwave0[14]="D\\Bx\\M/D\\By\\M"
		textwave0[15]="None"
		coef[8]=-1
		coef[14]=1
		coef[15]=-1
	ElseIf (cmpstr(textWave1[4], "Truncated tetrahedron")==0)
		textwave0[2]="D\\By\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H/D\\By\\M (C\\B2\\M)"
		Endif
		textwave0[8]="None"
		textwave0[14]="\\F'Symbol'b\\F'Arial' (deg)"
		textwave0[15]="None"
		coef[8]=-1
		coef[14]=70
		coef[15]=-1
		coef[6]=0.79
//		coef[14]=ceil(atan(coef[6]*2*sqrt(3))*180/pi)
	Elseif (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
		textwave0[2]="D\\Bcore\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\Bcore\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H\\Bcore\\M/D\\Bcore\\M (C\\B1\\M)"
		Else
			textwave0[6]="H\\Bcore\\M/D\\Bcore\\M (C\\B1\\M)"
			textwave0[7]="H\\Bcore\\M/D\\Bcore\\M (C\\B2\\M)"
		Endif		
		textwave0[8]="t\\Bshell\\M (nm)"
		textwave0[14]="None"
		textwave0[15]="None"
		coef[8]=0
		coef[14]=-1
		coef[15]=-1
	Elseif (cmpstr(textWave1[4], "Core-shell ripple")==0)
		textwave0[2]="D\\By\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H\\Bcore\\M/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H\\Bcore\\M/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H\\Bcore\\M/D\\By\\M (C\\B2\\M)"
		Endif		
		textwave0[8]="t\\Bshell\\M (nm)"
		textwave0[14]="D\\Bx\\M (nm)"
		textwave0[15]="Asymmetry"
		coef[8]=0
		coef[14]=coef[2]
		coef[15]=0
	Else
		textwave0[2]="D\\By\\M (nm)"
		If (cmpstr(textWave1[2], "Random organization")==0)
			textwave0[4]="None"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		If (cmpstr(textWave1[7], "Constant")==0)
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H/D\\By\\M (C\\B2\\M)"
		Endif		
		textwave0[8]="None"
		textwave0[14]="None"
		textwave0[15]="none"
		coef[8]=-1
		coef[14]=-1
		coef[15]=-1
	Endif
		
	askGISAXSparameters()
	askFITparameters()
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc1(ctrlName,popNum,popStr) : PopupMenuControl		// Structure factor
	String ctrlName
	Variable popNum
	String popStr
	Wave/D coef
	Wave/T textWave0,textWave1
	Execute/P/Q/Z "DELETEINCLUDE  \"Structure_"+textWave1[2]+"\""
	textwave1[2]=popstr
	Execute/P/Q/Z "INSERTINCLUDE  \"Structure_"+textWave1[2]+"\""
	Execute/P/Q/Z "COMPILEPROCEDURES "

	If (cmpstr(textWave1[2], "Random organization")==0)
		textwave0[4]="None"
		textwave0[5]="None"
//		textwave0[13]="None"
		textwave0[16]="None"
		textwave0[17]="None"
		coef[4]=-1
		coef[5]=-1
//		coef[13]=-1
		coef[16]=-1
		coef[17]=-1
	ElseIf (cmpstr(textWave1[2], "Paracrystal 1D")==0 || cmpstr(textWave1[2], "Paracrystal 2D-hex")==0)
		If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\Bcore\\M (C)"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		textwave0[5]="\\F'Symbol's\\F'Arial'\\By\\M (nm)"
//		textwave0[13]="None"
		textwave0[16]="None"
		textwave0[17]="None"
		coef[4]=1.5
		coef[5]=coef[2]*coef[4]*2/5
//		coef[13]=-1
		coef[16]=-1
		coef[17]=-1
	ElseIf (cmpstr(textWave1[2], "Paracrystal 2D-rec")==0)
		If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\Bcore\\M (C)"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		textwave0[5]="\\F'Symbol's\\F'Arial'\\By\\M (nm)"
//		textwave0[13]="None"
		textwave0[16]="\\F'Symbol'L\\F'Arial'\\Bx\\M/\\F'Symbol'L\\B\\F'Arial'y\\M"
		textwave0[17]="\\F'Symbol's\\F'Arial'\\Bx\\M/\\F'Symbol's\\F'Arial'\\By\\M"
		coef[4]=1.5
		coef[5]=coef[2]*coef[4]*2/5
//		coef[13]=-1
		coef[16]=1
		coef[17]=1
//	ElseIf (cmpstr(textWave1[2], "Paracrystal 3D")==0)
//		textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
//		textwave0[5]="\\F'Symbol's\\F'Arial'\\By\\M (nm)"
//		textwave0[16]="None"
//		textwave0[17]="None"
//		coef[4]=1.5
//		coef[5]=coef[2]*coef[4]*2/5
//		coef[16]=-1
//		coef[17]=-1

//		textwave0[13]="\\F'Symbol's\\F'Arial'\\Bz\\M (nm)"
//		coef[13]=coef[5]
	Else
		If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\Bcore\\M (C)"
		Else
			textwave0[4]="\\F'Symbol'L\\F'Arial'\\By\\M/D\\By\\M (C)"
		Endif
		textwave0[5]="\\F'Symbol'h\\F'Arial'\\Bhs"
//		textwave0[13]="None"
		textwave0[16]="None"
		textwave0[17]="None"
		coef[4]=1.5
		coef[5]=0.2
//		coef[13]=-1
		coef[16]=-1
		coef[17]=-1
	EndIf	

	askGISAXSparameters()
	askLAYERparameters()
	askFITparameters()
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc2(ctrlName,popNum,popStr) : PopupMenuControl		// Size distribution model
	String ctrlName
	Variable popNum
	String popStr
	Wave/D coef
	Wave/T textWave0,textWave1
	String cmd1,cmd2
	Execute/P/Q/Z "DELETEINCLUDE  \"LMA_"+textWave1[6]+"\""
	textwave1[6]=popstr
	Execute/P/Q/Z "INSERTINCLUDE  \"LMA_"+textWave1[6]+"\""
	Execute/P/Q/Z "COMPILEPROCEDURES "

	If (cmpstr(textWave1[6], "Monodisperse Approximation")==0)
		textwave0[3]="None"
		textwave0[9]="None"
		textwave0[10]="None"
		textwave0[11]="None"
		coef[3]=-1
		coef[9]=-1
		coef[10]=-1
		coef[11]=-1

		Execute/P/Q/Z "DELETEINCLUDE  \"Shapedist_"+textWave1[7]+"\""
		textWave1[7]="Constant"
//		textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		textwave0[7]="None"
//		textwave0[8]="None"
		coef[7]=-1
//		coef[8]=-1
		Execute/P/Q/Z "INSERTINCLUDE  \"Shapedist_"+textWave1[7]+"\""
		Execute/P/Q/Z "COMPILEPROCEDURES "
	Else
		textwave0[3]="FWHM (nm)"
		coef[3]=coef[2]*2/5
		If (cmpstr(textWave1[5], "DoubleGaussian")==0 || cmpstr(textWave1[5], "DoubleLog-normal")==0)
			textwave0[9]="Scale factor (k\\B2\\M)"
			textwave0[10]="D\\B2\\M (D\\B2\\M)"
			textwave0[11]="FWHM\\B2\\M (w\\B2\\M)"
			coef[9]=1
			coef[10]=coef[2]/2
			coef[11]=coef[3]/2
			cmd1="Dmin:=min(max(1e-6,coef[2]-3*coef[3]),max(1e-6,coef[10]-3*coef[11]))"
			cmd2="Dmax:=max(coef[2]+3*coef[3],coef[10]+3*coef[11])"
		ElseIf (cmpstr(textWave1[5], "Gaussian")==0)
			cmd1="Dmin:=max(1e-6,coef[2]-3*coef[3])"
			cmd2="Dmax:=coef[2]+3*coef[3]"
		ElseIf (cmpstr(textWave1[5], "Log-normal")==0)
			cmd1="Dmin:=max(1e-6,coef[2]-2*coef[3])"
			cmd2="Dmax:=coef[2]+3*coef[3]"
		ElseIf (cmpstr(textWave1[5], "Weibull")==0)
			cmd1="Dmin:=max(1e-6,coef[2]-3*coef[3])"
			cmd2="Dmax:=coef[2]+5*coef[3]"
		Endif

		Execute cmd1
		Execute cmd2

		If (cmpstr(textWave1[6], "Decoupling approximation")==0)
			If (cmpstr(textWave1[3], "Sandwiched layer")==0 || cmpstr(textWave1[3], "Buried layer")==0 || cmpstr(textWave1[3], "Correlated roughness")==0)
				Execute/P/Q/Z "DELETEINCLUDE  \"LMA_"+textWave1[6]+"\""
				textwave1[6]="Local monodisperse approximation"
				Execute/P/Q/Z "INSERTINCLUDE  \"LMA_"+textWave1[6]+"\""
				Execute/P/Q/Z "COMPILEPROCEDURES "
			Endif
		Endif
	EndIf
	
	askGISAXSparameters()
	askFITparameters()
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc3(ctrlName,popNum,popStr) : PopupMenuControl		// Distribution function
	String ctrlName
	Variable popNum
	String popStr
	Wave/D coef
	Wave/T textWave0,textWave1
	String cmd1,cmd2
	Execute/P/Q/Z "DELETEINCLUDE  \"Sizedist_"+textWave1[5]+"\""
	textwave1[5]=popstr
	Execute/P/Q/Z "INSERTINCLUDE  \"Sizedist_"+textWave1[5]+"\""
	Execute/P/Q/Z "COMPILEPROCEDURES "

	If (cmpstr(textWave1[6], "Monodisperse Approximation")!=0)
		If (cmpstr(textWave1[5], "Gaussian")==0 || cmpstr(textWave1[5], "Log-normal")==0 || cmpstr(textWave1[5], "Weibull")==0)
			textwave0[9]="None"
			textwave0[10]="None"
			textwave0[11]="None"
			coef[9]=-1
			coef[10]=-1
			coef[11]=-1
		Else
			textwave0[9]="Scale factor (k\\B2\\M)"
			textwave0[10]="D\\B2\\M (D\\B2\\M)"
			textwave0[11]="FWHM\\B2\\M (w\\B2\\M)"
			coef[9]=1
			coef[10]=coef[2]/2
			coef[11]=coef[3]/2
		Endif
	
		If (cmpstr(textWave1[5], "DoubleGaussian")==0 || cmpstr(textWave1[5], "DoubleLog-normal")==0)
			cmd1="Dmin:=min(max(1e-6,coef[2]-3*coef[3]),max(1e-6,coef[10]-3*coef[11]))"
			cmd2="Dmax:=max(coef[2]+3*coef[3],coef[10]+3*coef[11])"
		ElseIf (cmpstr(textWave1[5], "Gaussian")==0)
			cmd1="Dmin:=max(1e-6,coef[2]-3*coef[3])"
			cmd2="Dmax:=coef[2]+3*coef[3]"
		ElseIf (cmpstr(textWave1[5], "Log-normal")==0)
			cmd1="Dmin:=max(1e-6,coef[2]-2*coef[3])"
			cmd2="Dmax:=coef[2]+3*coef[3]"
		ElseIf (cmpstr(textWave1[5], "Weibull")==0)
			cmd1="Dmin:=max(1e-6,coef[2]-3*coef[3])"
			cmd2="Dmax:=coef[2]+5*coef[3]"
		Endif

		Execute cmd1
		Execute cmd2
	Endif
	
	askGISAXSparameters()
	askFITparameters()
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc4(ctrlName,popNum,popStr) : PopupMenuControl		// Layer geometry
	String ctrlName
	Variable popNum
	String popStr
	Wave/T textwave0,textwave1
	NVAR slayer
	Wave/D coef,nps
	Execute/P/Q/Z "DELETEINCLUDE  \"Form2_"+textWave1[3]+"\""
	textwave1[3]=popstr
	Execute/P/Q/Z "INSERTINCLUDE  \"Form2_"+textWave1[3]+"\""
	Execute/P/Q/Z "COMPILEPROCEDURES "

	If (cmpstr(textWave1[3],"Supported islands")==0)
		slayer=0
		nps=0
	Endif

	If (cmpstr(textWave1[3],"Correlated roughness")==0 && cmpstr(textWave1[2], "Paracrystal 3D")!=0)
		textwave0[12]="\\F'Symbol'x\\F'Arial'\\By\\M"
		textwave0[13]="\\F'Symbol'x\\F'Arial'\\Bz\\M"
		coef[12]=1
		coef[13]=1
	ElseIf(cmpstr(textWave1[2], "Paracrystal 3D")==0)
		textwave0[12]="none"
		coef[12]=-1
	Else
		textwave0[12]="none"
		textwave0[13]="none"
		coef[12]=-1
		coef[13]=-1
	Endif
	
	If (cmpstr(textWave1[6], "Decoupling approximation")==0)
		If (cmpstr(textWave1[3], "Sandwiched layer")==0 || cmpstr(textWave1[3], "Buried layer")==0 || cmpstr(textWave1[3], "Correlated roughness")==0)
			Execute/P/Q/Z "DELETEINCLUDE  \"LMA_"+textWave1[6]+"\""
			textwave1[6]="Local monodisperse approximation"
			Execute/P/Q/Z "INSERTINCLUDE  \"LMA_"+textWave1[6]+"\""
			Execute/P/Q/Z "COMPILEPROCEDURES "
		Endif
	Endif
	
	askGISAXSparameters()
	askLAYERparameters()
	askFITparameters()
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc5(ctrlName,popNum,popStr) : PopupMenuControl		// H/D model
	String ctrlName
	Variable popNum
	String popStr
	Wave/D coef
	Wave/T textwave0,textwave1
	
	Execute/P/Q/Z "DELETEINCLUDE  \"Shapedist_"+textWave1[7]+"\""
	textwave1[7]=popstr
	Execute/P/Q/Z "INSERTINCLUDE  \"Shapedist_"+textWave1[7]+"\""
	Execute/P/Q/Z "COMPILEPROCEDURES "
	
	If (cmpstr(textWave1[7], "Constant")==0)
		If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
			textwave0[6]="H\\Bcore\\M/D\\Bcore\\M (C\\B1\\M)"
		ElseIf (cmpstr(textWave1[4], "Core-shell ripple")==0)
			textwave0[6]="H\\Bcore\\M/D\\By\\M (C\\B1\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
		Endif
		textwave0[7]="None"
//		textwave0[8]="None"
		coef[7]=-1
//		coef[8]=-1
	ElseIf (cmpstr(textWave1[7], "Polynomial")==0)
		If (cmpstr(textWave1[4], "Core-shell cylinder")==0 || cmpstr(textWave1[4], "Core-shell spheroid")==0 || cmpstr(textWave1[4], "Core-shell hemispheroid")==0)
			textwave0[6]="H\\Bcore\\M/D\\Bcore\\M (C\\B1\\M)"
			textwave0[7]="H\\Bcore\\M/D\\Bcore\\M (C\\B2\\M)"
		ElseIf (cmpstr(textWave1[4], "Core-shell ripple")==0)
			textwave0[6]="H\\Bcore\\M/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H\\Bcore\\M/D\\By\\M (C\\B2\\M)"
		Else
			textwave0[6]="H/D\\By\\M (C\\B1\\M)"
			textwave0[7]="H/D\\By\\M (C\\B2\\M)"
		Endif
//		textwave0[8]="None"
		coef[7]=1
//		coef[8]=-1
//	ElseIf (cmpstr(textWave1[7], "Bell")==0)
//		textwave0[6]="H/D\\By\\M coef (C\\B1\\M)"
//		textwave0[7]="H/D\\By\\M coef (C\\B2\\M)"
//		textwave0[8]="H/D\\By\\M coef (C\\B3\\M)"
//		coef[6]=1
//		coef[7]=coef[2]
//		coef[8]=coef[2]*2/5
	EndIf	
	
	askFITparameters()
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function SetVarProcDminDmax(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR Dmin,Dmax
	
	String cmd=varName+"="+varName
	Execute cmd
	
	DoWindow/K Size_distribution
	DoWindow/K Shape_distribution
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------



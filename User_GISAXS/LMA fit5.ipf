#pragma rtGlobals=1		// Use modern global access method.

//----------------------------------------------------------------------------------------------------------------------------------

Function FitGisaxs1D(w,x) : FitFunc
	Wave/D w
	Variable x
	Wave/D wavevector_x,wavevector_y,wavevector_z

	Return Fit_GISAXS(wavevector_x[x],wavevector_y[x],wavevector_z[x])
//	Return Fit_GISAXS(wavevector_x[x],wavevector_y[x]+1e-2,wavevector_z[x])
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function FitGisaxs2D(w,x,y) : FitFunc
	Wave/D w
	Variable x
	Variable y
	Wave/D wavevector_x2D,wavevector_y2D,wavevector_z2D

	Return Fit_GISAXS(wavevector_x2D(x)(y),wavevector_y2D(x)(y),wavevector_z2D(x)(y))
//	Return Fit_GISAXS(wavevector_x2D(x)(y),wavevector_y2D(x)(y)+1e-2,wavevector_z2D(x)(y))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function askfittingparameters(dim)
	Variable dim
	Wave/T textWave0,textWave1
	Wave coefhold
	String titletemp,setvar,cmd,chkbox
	Variable i=0
	NewPanel/M/W=(8, 2.6, 14, 18.6)	//W=(left, top, right, bottom )
	
	TitleBox title0 title="Hold ?",frame=0,pos={185,15}
	
	For (i=0;i<numpnts(coef);i+=1)
		titletemp=textwave0[i]
		setvar="setvar"+num2str(i)
		chkbox="check"+num2str(i)
		SetVariable $setvar title=titletemp,pos={20,45+35*i},size={150,20},value=coef[i],fSize=13,limits={-Inf,Inf,0},bodyWidth=60,disable=0
		Checkbox $chkbox title="",pos={190,45+35*i},value=coefhold[i],proc=procChkbox
		If (cmpstr(textWave0[i], "None")==0)
			cmd="SetVariable "+setvar+" disable=1"
			Execute cmd
			cmd="Checkbox "+chkbox+" disable=1"
			Execute cmd
			coefhold[i]=1
		Endif
	Endfor
	If (dim==1)
		Button button0 title="Fit now",size={75,25},pos={95,8},proc=executeFit1d
		Button button1 title="Plot now",size={75,25},pos={8,8},proc=executeGraph1d
	Else
		Button button0 title="Fit now",size={75,25},pos={95,8},proc=executeFit2d
		Button button1 title="Plot now",size={75,25},pos={8,8},proc=executeGraph2d
	Endif
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function procChkbox(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if selected, 0 if not
	Wave coefhold
	
	Variable i=str2num(ctrlName[5,strlen(ctrlName)])
	coefhold[i]=checked
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function executeGraph1d(ctrlName) : ButtonControl
	String ctrlName
	Wave coef,wavevector
	Variable i
	String cmd
	NVAR cursmin,cursmax
	
	RemoveFromGraph/Z fit_scatintensity
	RemoveFromGraph/Z Res_scatintensity
	RemoveFromGraph/Z fit_peakposition

	cursmin=min(str2num(StringByKey("point", CsrInfo(A))),str2num(StringByKey("point", CsrInfo(B))))
	cursmax=max(str2num(StringByKey("point", CsrInfo(A))),str2num(StringByKey("point", CsrInfo(B))))

	If (numtype(cursmin)==2)		// si le curseur A n'existe pas sur le graph
		cursmin=0
	Endif
	If (numtype(cursmax)==2)		// si le curseur B n'existe pas sur le graph
		cursmax=numpnts(wavevector)-1
	Endif

	Duplicate/O/D/R=[cursmin,cursmax] scatintensity fit_scatintensity
	Duplicate/O/D/R=[cursmin,cursmax] wavevector fit_wavevector

	String startime
	Variable timerRatio
	Variable timerRefNum0
	Variable timerRefNum1
	Variable microSeconds

	Wavestats/Q fit_scatintensity
	timerRatio=16/V_npnts*100

	timerRefNum0 = startMSTimer
	timerRefNum1 = startMSTimer
	startime=time()
	if (timerRefNum0 == -1 || timerRefNum1 == -1)
		Abort "All timers are in use"
	endif

	If (numpnts(fit_scatintensity)>16)
		fit_scatintensity[0,15]=FitGisaxs1D(coef,x)

		microSeconds = stopMSTimer(timerRefNum0)
		Print "Run started at",startime,"---  Total time estimated:",microSeconds/1e6*100/timerRatio,"seconds"
	
		fit_scatintensity[16,numpnts(fit_scatintensity)-1]=FitGisaxs1D(coef,x)
	Else
		microSeconds = stopMSTimer(timerRefNum0)
		fit_scatintensity=FitGisaxs1D(coef,x)
	Endif

	microSeconds = stopMSTimer(timerRefNum1)
	Print "Run finished at",time(),"---  Total time elapsed:",microSeconds/1e6,"seconds"

	AppendToGraph fit_scatintensity vs fit_wavevector
	ModifyGraph lsize(fit_scatintensity)=2,rgb(fit_scatintensity)=(0,0,62720)
	Beep
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function executeFit1d(ctrlName) : ButtonControl
	String ctrlName
	Wave coefhold
	Variable i
	String cmd
	NVAR cursmin,cursmax
	
	DoWindow/K Fit1d_parameters
	
	RemoveFromGraph/Z fit_peakposition
	RemoveFromGraph/Z fit_scatintensity
	RemoveFromGraph/Z Res_scatintensity
	Killwaves/Z Res_scatintensity

	cursmin=min(str2num(StringByKey("point", CsrInfo(A))),str2num(StringByKey("point", CsrInfo(B))))
	cursmax=max(str2num(StringByKey("point", CsrInfo(A))),str2num(StringByKey("point", CsrInfo(B))))

	If (numtype(cursmin)==2)		// si le curseur A n'existe pas sur le graph
		Abort "Cursor A is not present on the graph !"
	Endif
	If (numtype(cursmax)==2)		// si le curseur B n'existe pas sur le graph
		Abort "Cursor B is not present on the graph !"
	Endif
	
	Duplicate/O/D/R=[cursmin,cursmax] wavevector fit_wavevector

	cmd="FuncFit/L="+num2str(cursmax-cursmin+1)+"/H=\""
	For (i=0;i<numpnts(coefhold);i+=1)
		cmd+=num2str(coefhold[i])
	Endfor
	cmd+="\"/NTHR=1/TBOX=0 FitGisaxs1D coef  scatintensity[pcsr(A),pcsr(B)] /D /R"
	Execute cmd
	RemoveFromGraph fit_scatintensity
	AppendToGraph fit_scatintensity vs fit_wavevector	
	ModifyGraph lsize(fit_scatintensity)=2,rgb(fit_scatintensity)=(0,0,62720)
	ModifyGraph lstyle(Res_scatintensity)=2,rgb(Res_scatintensity)=(0,0,62720)
	SetAxis/A Res_Left
	Print "Residual =",sum(Res_scatintensity)	
	Beep
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function executeGraph2d(ctrlName) : ButtonControl
	String ctrlName
	Wave coef,scatintensity2D
	NVAR Vmincol,Vmaxcol,rsmvar

	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Res_scatintensity2D,simgisaxs2D
	Duplicate/O/D scatintensity2D Res_scatintensity2D,simgisaxs2D
	
	////////////////////
	Variable npointsy=DimSize(simgisaxs2D,0)
	Variable nlines=ceil(256/npointsy)

	Wavestats/Q simgisaxs2D

	Variable timerRatio=(nlines*npointsy)/V_npnts*100
	String startime=time()
	Variable timerRefNum0=startMSTimer
	Variable timerRefNum1=startMSTimer
	Variable microSeconds
 
	if (timerRefNum0 == -1 || timerRefNum1 == -1)
		Abort "All timers are in use"
	endif

	If (V_npnts>256)
		simgisaxs2D[0,nlines-1]=FitGisaxs2D(coef,x,y)

		microSeconds = stopMSTimer(timerRefNum0)
		Print "Run started at",startime,"---  Total time estimated:",microSeconds/1e6*100/timerRatio,"seconds"

		simgisaxs2D[nlines,npointsy-1]=FitGisaxs2D(coef,x,y)
	Else
		simgisaxs2D=FitGisaxs2D(coef,x,y)
	EndIf

	microSeconds = stopMSTimer(timerRefNum1)
	Print "Run finished at",time(),"---  Total time elapsed:",microSeconds/1e6,"seconds"
	////////////////////////

	Res_scatintensity2D=scatintensity2D-simgisaxs2D
	Print "Residual =",sum(Res_scatintensity2D)	

	If (rsmvar!=1)
		Display/M/W=(9.4, 0.6, 11, 11);AppendImage Res_scatintensity2D vs {simtwothetaf,simalphaf}
		ModifyImage Res_scatintensity2D ctab= {*,*,Geo,0}
		ModifyGraph width=200, height={Plan,1,left,bottom},fSize=10,btLen=3,zero(bottom)=1
		Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
		Label left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
		DoWindow/C Res_gisaxs2D

		Display/M/W=(6.6, 5.3, 11, 11);AppendImage simgisaxs2D vs {simtwothetaf,simalphaf}
		ModifyImage simgisaxs2D ctab= {VminCol,VmaxCol,Geo,0}
		ModifyGraph width=200, height={Plan,1,left,bottom},fSize=10,btLen=3,zero(bottom)=1
		Label left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	Else
		Display/M/W=(9.4, 0.6, 11, 11);AppendImage Res_scatintensity2D vs {simtwothetaf,phif}
		ModifyImage Res_scatintensity2D ctab= {*,*,Geo,0}
		ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
		Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
		Label left "\\F'Symbol'j\\F'Arial' (deg)"
		DoWindow/C Res_gisaxs2D

		Display/M/W=(6.6, 5.3, 11, 11);AppendImage simgisaxs2D vs {simtwothetaf,phif}
		ModifyImage simgisaxs2D ctab= {*,*,Geo,0}
		ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
		Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Endif
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
	DoWindow/C Fit_gisaxs2D
	Beep
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function executeFit2d(ctrlName) : ButtonControl
	String ctrlName
	Wave coefhold
	NVAR VminCol,VmaxCol,rsmvar
	Variable i
	String cmd
	
	DoWindow/K Fit2d_parameters

	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Res_scatintensity2D,simgisaxs2D
	Duplicate/O/D scatintensity2D Res_scatintensity2D,simgisaxs2D

	Duplicate/O/D scatintensity2D Fit_scatintensity2D
	
	cmd="FuncFitMD/H=\""
	For (i=0;i<numpnts(coefhold);i+=1)
		cmd+=num2str(coefhold[i])
	Endfor
	cmd+="\"/NTHR=1/TBOX=0 FitGisaxs2D coef  scatintensity2D /D=Fit_scatintensity2D/R"
	Execute cmd
	
	DoWindow/C Res_gisaxs2D
	ModifyImage Res_scatintensity2D ctab= {*,*,Geo,0}
	Print "Residual =",sum(Res_scatintensity2D)	

	If (rsmvar!=1)
		Display/M/W=(6.6, 5.3, 11, 11);AppendImage Fit_scatintensity2D vs {simtwothetaf,simalphaf}
		ModifyImage Fit_scatintensity2D ctab= {VminCol,VmaxCol,Geo,0}
		ModifyGraph width=200, height={Plan,1,left,bottom},fSize=10,btLen=3,zero(bottom)=1
		Label left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	Else
		Display/M/W=(6.6, 5.3, 11, 11);AppendImage Fit_scatintensity2D vs {simtwothetaf,phif}
		ModifyImage Fit_scatintensity2D ctab= {*,*,Geo,0}
		ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
		Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Endif	
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
	DoWindow/C Fit_gisaxs2D
	Beep
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function bessel(u)
Variable u
Return (bessJ(1,u+1e-6))/(u+1e-6)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function rotz(q1,q2,q3,dxi)
	Variable q1,q2,q3,dxi
	Wave/D qprov
	qprov[0]=sqrt(q1^2+q2^2)*cos(atan(q2/q1)+dxi)
	qprov[1]=sqrt(q1^2+q2^2)*sin(atan(q2/q1)+dxi)
	qprov[2]=q3
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function roty(q1,q2,q3,dpsi)
	Variable q1,q2,q3,dpsi
	Wave/D qprov
	qprov[0]=sqrt(q1^2+q3^2)*cos(atan(q3/q1)+dpsi)
	qprov[1]=q2
	qprov[2]=sqrt(q1^2+q3^2)*sin(atan(q3/q1)+dpsi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function rotx(q1,q2,q3,dphi)
	Variable q1,q2,q3,dphi
	Wave/D qprov
	qprov[0]=q1
	qprov[1]=sqrt(q2^2+q3^2)*cos(atan(q3/q2)+dphi)
	qprov[2]=sqrt(q2^2+q3^2)*sin(atan(q3/q2)+dphi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function rotz_qx(q1,q2,q3,dxi)
	Variable q1,q2,q3,dxi
	Return sqrt(q1^2+q2^2)*cos(atan(q2/q1)+dxi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function rotz_qy(q1,q2,q3,dxi)
	Variable q1,q2,q3,dxi
	Return sqrt(q1^2+q2^2)*sin(atan(q2/q1)+dxi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function roty_qx(q1,q2,q3,dpsi)
	Variable q1,q2,q3,dpsi
	Return sqrt(q1^2+q3^2)*cos(atan(q3/q1)+dpsi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function roty_qz(q1,q2,q3,dpsi)
	Variable q1,q2,q3,dpsi
	Return sqrt(q1^2+q3^2)*sin(atan(q3/q1)+dpsi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function rotx_qy(q1,q2,q3,dphi)
	Variable q1,q2,q3,dphi
	Return sqrt(q2^2+q3^2)*cos(atan(q3/q2)+dphi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function rotx_qz(q1,q2,q3,dphi)
	Variable q1,q2,q3,dphi
	Return sqrt(q2^2+q3^2)*sin(atan(q3/q2)+dphi)
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function pangle()
	Wave coef
	Print "H=",coef[2]*coef[6],"nm, beta=",atan(2*coef[6]/(1-coef[15]))*180/pi,"deg, gamma=",atan(2*coef[6]/(1+coef[15]))*180/pi,"deg, Xi =",(coef[2]*coef[4])^3/2/coef[5]^2,"nm"
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function pvcoreshell()
	Wave coef
	Print "Vcore =",4/3*pi*(coef[2]/2)^3,"nm3, Vshell =",4/3*pi*(coef[2]/2+coef[15])^3-4/3*pi*(coef[2]/2)^3,"nm3, Vcore/Vtot =",(coef[2]/2)^3/(coef[2]/2+coef[15])^3,"Vshell/Vtot =",((coef[2]/2+coef[15])^3-(coef[2]/2)^3)/(coef[2]/2+coef[15])^3
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------




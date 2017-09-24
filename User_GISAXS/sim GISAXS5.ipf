#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
// 本文件全是在讲一个创建 GISAXS 的函数，参数：Map类型
Function CreateNewGISAXS2D(MapType)
	String MapType
	//取值并声明一些变量
	Variable qxval=NumVarOrDefault("qx_val",0)
	Variable qyval=NumVarOrDefault("qy_val",0)
	Variable qzval=NumVarOrDefault("qz_val",0)
	Variable qymin=NumVarOrDefault("qy_min",-2.5)
	Variable qymax=NumVarOrDefault("qy_max",2.5)
	Variable qzmin=NumVarOrDefault("qz_min",0)
	Variable qzmax=NumVarOrDefault("qz_max",2.5)
	Variable 	alphai=NumVarOrDefault("alphai_detec",0.3)
	Variable 	phi=NumVarOrDefault("phi_detec",0)
	Variable deltaq=NumVarOrDefault("delta_q",0.02)

	// 根据MapType的不同，提示输入信息
	Prompt alphai,"Incidence angle (�):"
	If (CmpStr(MapType,"QyQz_map")==0)
		Prompt phi,"Azimuthal angle (�):"
		Prompt qymin,"qy min (1/nm):"
		Prompt qymax,"qy max (1/nm):"
		Prompt qzmin,"qz min (1/nm):"
		Prompt qzmax,"qz max (1/nm):"
		Prompt qxval,"qx (1/nm):"
		Prompt deltaq,"Delta q (1/nm):"
		DoPrompt "Enter parameters", alphai, phi, qymin, qymax, qzmin, qzmax, qxval, deltaq
		//	ElseIf (CmpStr(MapType,"QxQz_map")==0)
		//		Prompt phi,"Azimuthal angle (�):"
		//		Prompt qymin,"qx min (1/nm):"
		//		Prompt qymax,"qx max (1/nm):"
		//		Prompt qzmin,"qz min (1/nm):"
		//		Prompt qzmax,"qz max (1/nm):"
		//		Prompt qyval,"qy (1/nm):"
		//		Prompt deltaq,"Delta q (1/nm):"
		//		DoPrompt "Enter parameters", alphai, phi, qymin, qymax, qzmin, qzmax, qyval, deltaq
	Elseif (CmpStr(MapType,"QxQy_map")==0)
		Prompt phi,"Azimuthal angle (�):"
		Prompt qymin,"qy min (1/nm):"
		Prompt qymax,"qy max (1/nm):"
		Prompt qzmin,"qx min (1/nm):"
		Prompt qzmax,"qx max (1/nm):"
		Prompt qzval,"qz (1/nm):"
		Prompt deltaq,"Delta q (1/nm):"
		DoPrompt "Enter parameters", alphai, phi, qymin, qymax, qzmin, qzmax, qzval, deltaq
	Else
		Prompt phi,"Delta phi (�):"
		Prompt qymin,"qy min (1/nm):"
		Prompt qymax,"qy max (1/nm):"
		Prompt qzmin,"phi min (1/nm):"
		Prompt qzmax,"phi max (1/nm):"
		Prompt qzval,"qz (1/nm):"
		Prompt deltaq,"Delta q (1/nm):"
		DoPrompt "Enter parameters", alphai, phi, qymin, qymax, qzmin, qzmax, qzval, deltaq
	EndIf	

	// 声明一些全局变量
	Variable/G qx_val=qxval
	Variable/G qy_val=qyval
	Variable/G qz_val=qzval
	Variable/G qy_min=qymin
	Variable/G qy_max=qymax
	Variable/G qz_min=qzmin
	Variable/G qz_max=qzmax
	Variable/G alphai_detec=alphai
	Variable/G phi_detec=phi
	Variable/G delta_q=deltaq

	DoWindow/K Sim_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	Killwaves/Z simgisaxs2D
	
	Variable npointsy, npointsz
	
	// 当MapType为下列三者之一时，执行这部逻辑，否则执行Else部分的逻辑，大体上设置x轴y轴的范围，在控制台输出了一些信息
	If (CmpStr(MapType,"QyQz_map")==0 || CmpStr(MapType,"QxQz_map")==0 || CmpStr(MapType,"QxQy_map")==0)
		npointsy=ceil((qy_max-qy_min)/deltaq)+1
		npointsz=ceil((qz_max-qz_min)/deltaq)+1
		Make/N=(npointsy,npointsz)/D/O simgisaxs2D
		SetScale/P x qy_min,deltaq,"", simgisaxs2D
		SetScale/P y qz_min,deltaq,"", simgisaxs2D
		Print "Image size =",DimSize(simgisaxs2D,0),"x",DimSize(simgisaxs2D,1),"(resolution =",deltaq,"1/nm)"
		Print "Incidence angle =",alphai_detec,"deg, Azimuthal angle =",phi_detec,"deg"
	Else
		npointsy=ceil((qy_max-qy_min)/deltaq)+1
		npointsz=ceil((qz_max-qz_min)/phi)+1
		Make/N=(npointsy,npointsz)/D/O simgisaxs2D
		SetScale/P x qy_min,deltaq,"", simgisaxs2D
		SetScale/P y qz_min,phi,"", simgisaxs2D
		Print "Image size =",DimSize(simgisaxs2D,0),"x",DimSize(simgisaxs2D,1),"(resolution =",deltaq,"1/nm)"
		Print "Incidence angle =",alphai_detec,"deg, dPhi =",phi_detec,"deg"
	Endif
	

	////////////////////
	String startime
	Variable timerRatio
	Variable timerRefNum0
	Variable timerRefNum1
	Variable microSeconds
	Variable nlines=ceil(256/npointsy)

	Duplicate/O simgisaxs2d qx2d,qy2d,qz2d
	Wavestats/Q simgisaxs2D
	timerRatio=(nlines*npointsy)/V_npnts*100

	If (CmpStr(MapType,"QyQz_map")==0)
		qx2d=qx_val*cos(phi_detec*pi/180)+x*sin(phi_detec*pi/180)
		qy2d=-qx_val*sin(phi_detec*pi/180)+x*cos(phi_detec*pi/180)
		qz2d=y
//	ElseIf (CmpStr(MapType,"QxQz_map")==0)
//		qx2d=x*cos(phi_detec*pi/180)+qy_val*sin(phi_detec*pi/180)
//		qy2d=-x*sin(phi_detec*pi/180)+qy_val*cos(phi_detec*pi/180)
//		qz2d=y
	ElseIf (CmpStr(MapType,"QxQy_map")==0)
		qx2d=y*cos(phi_detec*pi/180)+x*sin(phi_detec*pi/180)
		qy2d=-y*sin(phi_detec*pi/180)+x*cos(phi_detec*pi/180)
		qz2d=qz_val
	Else
		qx2d=x*sin(y*pi/180)
		qy2d=x*cos(y*pi/180)
		qz2d=qz_val
		phi_detec=0
	EndIf	

	timerRefNum0 = startMSTimer
	timerRefNum1 = startMSTimer
	startime=time()
	if (timerRefNum0 == -1 || timerRefNum1 == -1)
		Abort "All timers are in use"
	endif

	If (V_npnts>256)
		simgisaxs2D[0,nlines-1]=Fit_GISAXS(qx2d[p][q],qy2d[p][q],qz2d[p][q])

		microSeconds = stopMSTimer(timerRefNum0)
		Print "Run started at",startime,"---  Total time estimated:",microSeconds/1e6*100/timerRatio,"seconds"

		simgisaxs2D[nlines,npointsy-1]=Fit_GISAXS(qx2d[p][q],qy2d[p][q],qz2d[p][q])
	Else
		microSeconds = stopMSTimer(timerRefNum0)
		simgisaxs2D=Fit_GISAXS(qx2d,qy2d,qz2d)
	EndIf

	microSeconds = stopMSTimer(timerRefNum1)
	Print "Run finished at",time(),"---  Total time elapsed:",microSeconds/1e6,"seconds"
	Killwaves qx2d,qy2d,qz2d
	////////////////////////

	Display/M/W=(0.2, 5.3, 11, 11);AppendImage simgisaxs2D
	ControlBar 30
	Button button0, size={60,20}, pos={200,5}, title="Update",fsize=11
	Button button6, size={60,20}, pos={400,5}, proc=ButtonProc_logscale, title="Log. scale",fsize=11
	Button button66, size={60,20}, pos={320,5}, proc=ButtonProc_linscale, title="Lin. scale",fsize=11,disable=2
	ModifyImage simgisaxs2D ctab= {*,*,Geo,0}
	If (CmpStr(MapType,"QyQz_map")==0)
		Label bottom "q\\By\\M (nm\\S-1\\M)"
		Label left "q\\Bz\\M (nm\\S-1\\M)"
		Button button0, proc=ButtonProc_newQyQz
		SetVariable setvar2 title="qx (nm)",pos={15,5},size={100,18},value=qx_val,limits={-inf,inf,0.1}
		ModifyGraph fSize=14,width=226.772,height={Plan,1,left,bottom},btLen=5,zero=1
//	ElseIf (CmpStr(MapType,"QxQz_map")==0)
//		Label bottom "q\\Bx\\M (nm\\S-1\\M)"
//		Label left "q\\Bz\\M (nm\\S-1\\M)"
//		Button button0, proc=ButtonProc_newQxQz
//		SetVariable setvar2 title="qy (nm)",pos={15,5},size={100,18},value=qy_val,limits={-inf,inf,0.1}
//		ModifyGraph fSize=14,width=226.772,height={Plan,1,left,bottom},btLen=5,zero=1
	ElseIf (CmpStr(MapType,"QxQy_map")==0)
		Label bottom "q\\By\\M (nm\\S-1\\M)"
		Label left "q\\Bx\\M (nm\\S-1\\M)"
		Button button0, proc=ButtonProc_newQxQy
		SetVariable setvar2 title="qz (nm)",pos={15,5},size={100,18},value=qz_val,limits={-inf,inf,0.1}
		ModifyGraph fSize=14,width=226.772,height={Plan,1,left,bottom},btLen=5,zero=1
	Else
		Label bottom "q\\By\\M (nm\\S-1\\M)"
		Label left "\\F'Symbol'j\\F'Arial' (deg)"
		Button button0, proc=ButtonProc_newQyPhi
		SetVariable setvar2 title="qz (nm)",pos={15,5},size={100,18},value=qz_val,limits={-inf,inf,0.1}
		ModifyGraph fSize=14,width=226.772,height={Aspect,1},btLen=5,zero=1
	EndIf	
	SetAxis/A
	ColorScale/C/N=text0/X=0.00/Y=4.00/F=0/A=RC/E image=simgisaxs2D,heightPct=100,width=10,lblMargin=-5,tickLen=5.00,fsize=14,prescaleExp=0,"Intensity (arb. units)"
	ShowInfo
	DoWindow/C Sim_gisaxs2D
	
	Variable/G Vmincol=V_min
	Variable/G Vmaxcol=V_max

End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_newQyQz(ctrlName) : ButtonControl
	String ctrlName
	Wave/D simgisaxs2D,qx2d,qy2d,qz2d
	NVAR qx_val,phi_detec
	
	Duplicate/O simgisaxs2d qx2d,qy2d,qz2d

	qx2d=qx_val*cos(phi_detec*pi/180)+x*sin(phi_detec*pi/180)
	qy2d=-qx_val*sin(phi_detec*pi/180)+x*cos(phi_detec*pi/180)
	qz2d=y

	simgisaxs2D=Fit_GISAXS(qx2d,qy2d,qz2d)

	Killwaves qx2d,qy2d,qz2d
	ColorScale/C/N=text0 "Intensity (arb. units)"
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

//Function ButtonProc_newQxQz(ctrlName) : ButtonControl
//	String ctrlName
//	Wave/D simgisaxs2D,qx2d,qy2d,qz2d
//	NVAR qy_val,phi_detec
//	
//	Duplicate/O simgisaxs2d qx2d,qy2d,qz2d
//
//	qx2d=x*cos(phi_detec*pi/180)+qy_val*sin(phi_detec*pi/180)
//	qy2d=-x*sin(phi_detec*pi/180)+qy_val*cos(phi_detec*pi/180)
//	qz2d=y
//
//	simgisaxs2D=Fit_GISAXS(qx2d,qy2d,qz2d)
//
//	Killwaves qx2d,qy2d,qz2d
//	Button button6 disable=0
//	ColorScale/C/N=text0 "Intensity (arb. units)"
//End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_newQxQy(ctrlName) : ButtonControl
	String ctrlName
	Wave/D simgisaxs2D,qx2d,qy2d,qz2d
	NVAR qz_val,phi_detec
	
	Duplicate/O simgisaxs2d qx2d,qy2d,qz2d

	qx2d=y*cos(phi_detec*pi/180)+x*sin(phi_detec*pi/180)
	qy2d=-y*sin(phi_detec*pi/180)+x*cos(phi_detec*pi/180)
	qz2d=qz_val

	simgisaxs2D=Fit_GISAXS(qx2d,qy2d,qz2d)

	Killwaves qx2d,qy2d,qz2d
	ColorScale/C/N=text0 "Intensity (arb. units)"
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_newQyPhi(ctrlName) : ButtonControl
	String ctrlName
	Wave/D simgisaxs2D,qx2d,qy2d,qz2d
	NVAR qz_val
	
	Duplicate/O simgisaxs2d qx2d,qy2d,qz2d

	qx2d=x*sin(y*pi/180)
	qy2d=x*cos(y*pi/180)
	qz2d=qz_val

	simgisaxs2D=Fit_GISAXS(qx2d,qy2d,qz2d)

	Killwaves qx2d,qy2d,qz2d
	ColorScale/C/N=text0 "Intensity (arb. units)"
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
//�������������������������������������������������������������������������������������������������������������������������������
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function CreateNewGISAXS1D(CutType)
	String CutType
	Variable qxval=NumVarOrDefault("qx_val",0)
	Variable qyval=NumVarOrDefault("qy_val",0)
	Variable qzval=NumVarOrDefault("qz_val",0)
	Variable qymin=NumVarOrDefault("qy_min",-2.5)
	Variable qymax=NumVarOrDefault("qy_max",2.5)
	Variable qzmin=NumVarOrDefault("qz_min",0)
	Variable qzmax=NumVarOrDefault("qz_max",2.5)
	Variable 	alphai=NumVarOrDefault("alphai_detec",0.3)
	Variable 	phi=NumVarOrDefault("phi_detec",0)
	Variable deltaq=NumVarOrDefault("delta_q",0.02)

	Prompt alphai,"Incidence angle (�):"
	Prompt phi,"Azimuthal angle (�):"
	If (CmpStr(CutType,"Qy_cut")==0)
		Prompt qymin,"qy min (1/nm):"
		Prompt qymax,"qy max (1/nm):"
		Prompt qzval,"qz (1/nm):"
		Prompt qxval,"qx (1/nm)"
		Prompt deltaq,"Delta q (1/nm):"
		DoPrompt "Enter parameters", alphai, phi, qymin, qymax, qzval, qxval, deltaq
	ElseIf (CmpStr(CutType,"Qz_cut")==0)
		Prompt qzmin,"qz min (1/nm):"
		Prompt qzmax,"qz max (1/nm):"
		Prompt qyval,"qy (1/nm):"
		Prompt qxval,"qx (1/nm)"
		Prompt deltaq,"Delta q (1/nm):"
		DoPrompt "Enter parameters", alphai, phi, qzmin, qzmax, qyval, qxval, deltaq
	EndIf	

	Variable/G qx_val=qxval
	Variable/G qy_val=qyval
	Variable/G qz_val=qzval
	Variable/G qy_min=qymin
	Variable/G qy_max=qymax
	Variable/G qz_min=qzmin
	Variable/G qz_max=qzmax
	Variable/G alphai_detec=alphai
	Variable/G phi_detec=phi
	Variable/G delta_q=deltaq

	DoWindow/K Sim_gisaxs1D
	Killwaves/Z simgisaxs1D
	
	Variable npointsy, npointsz
	String startime
	Variable timerRatio
	Variable timerRefNum0
	Variable timerRefNum1
	Variable microSeconds
	
	If (CmpStr(CutType,"Qy_cut")==0)
		npointsy=ceil((qy_max-qy_min)/deltaq)+1
		Make/N=(npointsy)/D/O simgisaxs1D
		SetScale/P x qy_min,deltaq,"", simgisaxs1D
		Print "Incidence angle =",alphai_detec,"deg, Azimuthal angle =",phi_detec,"deg"
	ElseIf (CmpStr(CutType,"Qz_cut")==0)
		npointsz=ceil((qz_max-qz_min)/deltaq)+1
		Make/N=(npointsz)/D/O simgisaxs1D
		SetScale/P x qz_min,deltaq,"", simgisaxs1D
		Print "Incidence angle =",alphai_detec,"deg, Azimuthal angle =",phi_detec,"deg"
	EndIf	

	////////////////////
	Duplicate/O simgisaxs1d qx1d,qy1d,qz1d
	Wavestats/Q simgisaxs1D
	timerRatio=16/V_npnts*100
	
	If (CmpStr(CutType,"Qy_cut")==0)
		qx1d=qx_val*cos(phi_detec*pi/180)+x*sin(phi_detec*pi/180)
		qy1d=-qx_val*sin(phi_detec*pi/180)+x*cos(phi_detec*pi/180)
		qz1d=qz_val
	Elseif (CmpStr(CutType,"Qz_cut")==0)
		qx1d=qx_val*cos(phi_detec*pi/180)+qy_val*sin(phi_detec*pi/180)
		qy1d=-qx_val*sin(phi_detec*pi/180)+qy_val*cos(phi_detec*pi/180)
		qz1d=x
	EndIf	

	timerRefNum0 = startMSTimer
	timerRefNum1 = startMSTimer
	startime=time()
	if (timerRefNum0 == -1 || timerRefNum1 == -1)
		Abort "All timers are in use"
	endif

	If (numpnts(simgisaxs1d)>16)
		simgisaxs1D[0,15]=Fit_GISAXS(qx1d[p],qy1d[p],qz1d[p])

		microSeconds = stopMSTimer(timerRefNum0)
		Print "Run started at",startime,"---  Total time estimated:",microSeconds/1e6*100/timerRatio,"seconds"
	
		simgisaxs1D[16,numpnts(simgisaxs1D)-1]=Fit_GISAXS(qx1d[p],qy1d[p],qz1d[p])
	Else
		microSeconds = stopMSTimer(timerRefNum0)
		simgisaxs1D=Fit_GISAXS(qx1d,qy1d,qz1d)
	Endif

	microSeconds = stopMSTimer(timerRefNum1)
	Print "Run finished at",time(),"---  Total time elapsed:",microSeconds/1e6,"seconds"
	Killwaves qx1d,qy1d,qz1d
	////////////////////////

	Display/M/W=(0.2, 5.3, 13.2, 12.3) simgisaxs1d	// /W=(left, top, right, bottom )
	ModifyGraph mirror=2, btLen=5, fSize=14, lsize=1.5, zero(bottom)=1
	SetAxis/A/E=1 left
	SetAxis/A/E=0 bottom
	DoWindow/C Sim_gisaxs1D
	ControlBar 30
	Button button0, size={60,20}, pos={215,5}, title="Update",fsize=11
	Button intens0 title="Guinier", proc=ButtonProc_simguinierplot, pos={310,5}, size={60,20},fsize=11
	Button intens21 title="Lin. scale", proc=ButtonProc_linscale1d, pos={400,5}, size={60,20},fsize=11, disable=1
	Button intens22 title="Log. scale", proc=ButtonProc_logscale1d, pos={400,5}, size={60,20},fsize=11
	If (CmpStr(CutType,"Qy_cut")==0)
		Label left "I(q\\By\\M) (arb. units)"
		Label bottom "q\\By\\M (nm\\S-1\\M)"
		SetVariable setvar2 title="qx (nm)",pos={10,5},size={85,18},value=qx_val,limits={-inf,inf,0.1}
		SetVariable setvar3 title="qz (nm)",pos={105,5},size={85,18},value=qz_val,limits={-inf,inf,0.1}
		Button button0, proc=ButtonProc_newQycut
	Elseif (CmpStr(CutType,"Qz_cut")==0)
		Label left "I(q\\Bz\\M) (arb. units)"
		Label bottom "q\\Bz\\M (nm\\S-1\\M)"
		SetVariable setvar2 title="qx (nm)",pos={10,5},size={85,18},value=qx_val,limits={-inf,inf,0.1}
		SetVariable setvar3 title="qy (nm)",pos={105,5},size={85,18},value=qy_val,limits={-inf,inf,0.1}
		Button button0, proc=ButtonProc_newQzcut
	EndIf	

End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_newQycut(ctrlName) : ButtonControl
	String ctrlName
	Wave/D simgisaxs1D,qx1d,qy1d,qz1d
	NVAR qx_val,qz_val,phi_detec

	RemoveFromGraph/Z simgisaxs1dold	
	Duplicate/O simgisaxs1d qx1d,qy1d,qz1d,simgisaxs1dold
	AppendToGraph simgisaxs1dold
	ModifyGraph rgb(simgisaxs1dold)=(0,52224,26368)
	
	qx1d=qx_val*cos(phi_detec*pi/180)+x*sin(phi_detec*pi/180)
	qy1d=-qx_val*sin(phi_detec*pi/180)+x*cos(phi_detec*pi/180)
	qz1d=qz_val

	simgisaxs1D=Fit_GISAXS(qx1d,qy1d,qz1d)

	Killwaves qx1d,qy1d,qz1d
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_newQzcut(ctrlName) : ButtonControl
	String ctrlName
	Wave/D simgisaxs1D,qx1d,qy1d,qz1d
	NVAR qx_val,qy_val,phi_detec
	
	RemoveFromGraph/Z simgisaxs1dold	
	Duplicate/O simgisaxs1d qx1d,qy1d,qz1d,simgisaxs1dold
	AppendToGraph simgisaxs1dold
	ModifyGraph rgb(simgisaxs1dold)=(0,52224,26368)

	qx1d=qx_val*cos(phi_detec*pi/180)+qy_val*sin(phi_detec*pi/180)
	qy1d=-qx_val*sin(phi_detec*pi/180)+qy_val*cos(phi_detec*pi/180)
	qz1d=x

	simgisaxs1D=Fit_GISAXS(qx1d,qy1d,qz1d)

	Killwaves qx1d,qy1d,qz1d
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_simguinierplot(ctrlName) : ButtonControl
	String ctrlName
	Wave/D simgisaxs1D
	DoWindow/K Guinier_plot
	Duplicate/O/D simgisaxs1D wavevector2,logscatintensity
	wavevector2=x^2
	logscatintensity=Ln(simgisaxs1D)
	Display/W=(480, 298, 880, 528) logscatintensity vs wavevector2
	ModifyGraph mirror=2, btLen=5, fSize=14, zero(bottom)=1
	Label bottom "q\\S2\\M (nm\\S-2\\M)"
	Label left "Ln I(q) (arb. units)"
	ShowInfo
	ControlBar 30
	Button guinier0 title="Diameter", proc=ButtonProc_guinierslope, pos={10,5}, size={60,20},fsize=11
	Button guinier1 title="Differentiate", proc=ButtonProc_differentiate, pos={80,5}, size={75,20},fsize=11
	Button guinier2 title="Autoscale", proc=ButtonProc_autoscale, pos={165,5}, size={60,20},fsize=11
	DoWindow/C Guinier_plot
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

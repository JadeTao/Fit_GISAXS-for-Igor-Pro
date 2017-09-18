#pragma rtGlobals=1		// Use modern global access method.

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function LoadNewGISAXS(Beamline)
	String Beamline

	Variable grazingangle=NumVarOrDefault("alphai_detec",0.3)
	Variable azimuthangle=NumVarOrDefault("phi_detec",0)
	Variable Direct_X=Round(NumVarOrDefault("DirectXdial",650))
	Variable Direct_Y=Round(NumVarOrDefault("DirectYdial",1100))
	Variable s2d_dist=NumVarOrDefault("distance",570)
	Variable nrj=1239.97/NumVarOrDefault("long_onde",0.155)

	Prompt grazingangle,"Incidence angle (?:"
	Prompt azimuthangle,"Azimuthal angle (?:"
	Prompt Direct_X,"Direct beam X pixel:"
	Prompt Direct_Y,"Direct beam Y pixel:"
	Prompt s2d_dist,"Sample-detector distance  (mm):"
	Prompt nrj, "Energy (eV):"

	DoPrompt "Enter parameters", grazingangle, azimuthangle, Direct_X, Direct_Y, s2d_dist, nrj

	DoWindow/K NewGISAXS
	DoWindow/K cut
	DoWindow/K cut2d
	DoWindow/K qyqxmap
	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	DoWindow/K Guinier_plot

	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D

	//-------------------Définition des variables-----------------------------------	
		
	Variable/G alphai_detec=grazingangle
	Variable/G phi_detec=azimuthangle
	Variable/G DirectXdial=Direct_X
	Variable/G DirectYdial=Direct_Y
	Variable/G distance=s2d_dist
	Variable/G long_onde=1239.97/nrj

	Variable/G DirectXinit=Direct_X
	Variable/G DirectYinit=Direct_Y
	Variable/G resolutionX,resolutionY

	Variable cutpos=NumVarOrDefault("cut_pos",0)
	Variable cutangle=NumVarOrDefault("cut_angle",0)
	Variable cutwidth=NumVarOrDefault("cut_width",0.1)
	Variable/G cut_pos=cutpos
	Variable/G cut_angle=cutangle
	Variable/G cut_width=cutwidth

	Variable/G VminCol,VmaxCol
	Variable/G varbinning=0
	Variable/G cursmin,cursmax

	//-------------------Chargement de l'image gisaxs2D et définition de l'espace réciproque (qy,qz)-----------------------------------	

	String cmd="Load_"+Beamline+"()"
	Execute cmd
	
	Variable/G DirectX=DirectXinit
	Variable/G DirectY=DirectYinit
	
	Redimension/D gisaxs2D	
	Duplicate/O/D gisaxs2D gisaxs2D_detec
	Make/O/N=(DimSize(gisaxs2D,0)+1)/D twothetaf
	Make/O/N=(DimSize(gisaxs2D,1)+1)/D alphaf
	twothetaf=atan((p-DirectX)*resolutionX/distance)*180/pi
//	alphaf=atan((p-DirectY)*resolutionY/distance-tan(alphai_detec*pi/180))*180/pi
	alphaf=atan((p-DirectY)*resolutionY/distance)*180/pi-alphai_detec
	
	Duplicate/O/D twothetaf twothetaf_detec
	Duplicate/O/D alphaf alphaf_detec
	
	WaveStats/Q gisaxs2D
	VminCol=0
	VmaxCol=abs(V_avg*10)
	
	Display/M/W=(0.2, 5.3, 11, 11);AppendImage gisaxs2d vs {twothetaf,alphaf} 
	DoWindow/C NewGISAXS
	ControlBar 60
	SetVariable minCol, size={85,15}, pos={5,6}, proc=SetVarProc_ApplyColors, title="Min.", limits={0,Inf,0}, value= VminCol,fsize=11,bodyWidth=50//, format="%4.4g"
	SetVariable maxCol, size={85,15}, pos={5,31},proc=SetVarProc_ApplyColors, title="Max.", limits={0,Inf,0}, value= VmaxCol,fsize=11,bodyWidth=50//, format="%4.4g"
	Slider slider0 pos={95,5},size={21,50},vert=1,side=0,proc=SliderProc,variable=VmaxCol,limits={V_max*2,0,V_max/2e16}
	Button button5, size={60,20}, pos={160,7}, proc=ButtonProc_1dcut,title="1D cut",fsize=11
	Button button5bis, size={60,20}, pos={230,7}, proc=ButtonProc_2dcut,title="2D fit",fsize=11
	Button button7, size={60,20}, pos={300,7}, proc=ButtonProc_autoscale, title="Autoscale",fsize=11
	Button button6, size={60,20}, pos={160,30}, proc=ButtonProc_logscale, title="Log. scale",fsize=11
	Button button66, size={60,20}, pos={160,30}, proc=ButtonProc_linscale, title="Lin. scale",fsize=11,disable=1
	Button button9, size={60,20}, pos={230,30}, proc=ButtonProc_symimage, title="Symmetry",fsize=11
	Button button4bis, size={60,20}, pos={300,30}, proc=ButtonProc_binning, title="Binning",fsize=11
	Button button4, size={60,40}, pos={510,7}, proc=ButtonProc_reset, title="Reset",fsize=11
	Button button8, size={60,40}, pos={440,7}, proc=ButtonProc_nmscale, title="1/nm",fsize=11
	Button button8bis, size={60,40}, pos={440,7}, proc=ButtonProc_degscale, title="deg",fsize=11,disable=1
	SetVariable setvarbin title=" ",size={20,20}, pos={365,31}, disable=2,value=varbinning, limits={-inf,inf,0}

	If (cmpstr(Beamline,"id01")==0)
		Button button5ter, size={60,20}, pos={370,7}, proc=ButtonProc_RSMid01,title="RSM",fsize=11
	Endif
	If (cmpstr(Beamline,"d2am")==0)
		Button button5ter, size={60,20}, pos={370,7}, proc=ButtonProc_RSMd2am,title="RSM",fsize=11
	Endif
	If (cmpstr(Beamline,"d2am_xpad")==0)
		Button button5ter, size={60,20}, pos={370,7}, proc=ButtonProc_RSMd2amxpad,title="RSM",fsize=11
	Endif
	If (cmpstr(Beamline,"sixs_bin")==0)
		Button button5ter, size={60,20}, pos={370,7}, proc=ButtonProc_RSMsixs,title="RSM",fsize=11
	Endif
	If (cmpstr(Beamline,"sixs_asc")==0)
		Button button5ter, size={60,20}, pos={370,7}, proc=ButtonProc_RSMsixsasc,title="RSM",fsize=11
	Endif

	ModifyImage gisaxs2D ctab= {VminCol,VmaxCol,Geo,0}
	ModifyGraph fSize=14,width=283.465,height={Plan,1,left,bottom},btLen=5,zero(bottom)=1
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
	Label left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	SetAxis/A bottom
	SetAxis/A/E=1 left
	ColorScale/C/N=text0/X=0.00/Y=4.00/F=0/A=RC/E image=gisaxs2D,heightPct=100,width=10,lblMargin=-5,tickLen=5.00,fsize=14,prescaleExp=0,"Intensity (arb. units)"
	ShowInfo
	
	If (cmpstr(Beamline,"id10b")==0)
		ModifyGraph height={Aspect,1}
		SetAxis/A/E=0 left
	Endif


	//-------------------Impression des infos-----------------------------------	

	Print "Image size =",DimSize(gisaxs2D,0),"x",DimSize(gisaxs2D,1),"(Resolution =",resolutionX,"x",resolutionY,"mm)",", Direct beam = (",Direct_X,",",Direct_Y,")",", Sample-to-detector distance =",Distance,"mm"
	Print "Energy =",1239.97/long_onde,"eV, Wavelength =",long_onde,"nm, Incidence angle =",alphai_detec,"deg, Azimuthal angle =",phi_detec,"deg"
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function SetVarProc_ApplyColors(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	NVAR VminCol, VmaxCol
	String imname=WaveList("*gisaxs*", ";","WIN:")
	imname=imname[0,strlen(imname)-2]
	String colorcmd=StringByKey("RECREATION",ImageInfo(WinName(0,1),imname,0))
	Variable i=7
	Do
		i+=1
	While (abs(cmpstr(colorcmd[i], "," )) > 0)
	Do
		i+=1
	While (abs(cmpstr(colorcmd[i], "," )) > 0)
	Variable j=i
	Do
		j+=1
	While (abs(cmpstr(colorcmd[j], "}" )) > 0)
	colorcmd=colorcmd[i,j]
	colorcmd="ModifyImage "+imname+"  ctab= {"+num2str(VminCol)+","+num2str(VmaxCol)+colorcmd
	Execute/Q colorcmd
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function SliderProc(ctrlName,sliderValue,event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	// bit field: bit 0: value set, 1: mouse down, 2: mouse up, 3: mouse moved

	if(event %& 0x1)	// bit 0, value set

	endif

	NVAR VminCol, VmaxCol
	String imname=WaveList("*gisaxs*", ";","WIN:")
	imname=imname[0,strlen(imname)-2]
	String colorcmd=StringByKey("RECREATION",ImageInfo(WinName(0,1),imname,0))
	Variable i=7
	Do
		i+=1
	While (abs(cmpstr(colorcmd[i], "," )) > 0)
	Do
		i+=1
	While (abs(cmpstr(colorcmd[i], "," )) > 0)
	Variable j=i
	Do
		j+=1
	While (abs(cmpstr(colorcmd[j], "}" )) > 0)
	colorcmd=colorcmd[i,j]
	colorcmd="ModifyImage "+imname+"  ctab= {"+num2str(VminCol)+","+num2str(VmaxCol)+colorcmd
	Execute/Q colorcmd
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_autoscale(ctrlName) : ButtonControl
	String ctrlName
	SetAxis/A/E=0
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_linscale(ctrlName) : ButtonControl
	String ctrlName
	NVAR VminCol, VmaxCol
	String imname=WaveList("*gisaxs*", ";","WIN:")
	imname=imname[0,strlen(imname)-2]
	
	// ModifyImage $imname log=0
	// ColorScale/C/N=text0 log=0
	If (cmpstr(imname,"simgisaxs2D")==0)
		Button button6 disable=0
		Button button66 disable=2
	Else
		Button button6 disable=0
		Button button66 disable=1
	EndIf
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_logscale(ctrlName) : ButtonControl
	String ctrlName
	NVAR VminCol, VmaxCol
	String imname=WaveList("*gisaxs*", ";","WIN:")
	imname=imname[0,strlen(imname)-2]
	
	Variable i=0
	Variable j=0

	If (cmpstr(imname,"simgisaxs2D")==0)
		Wavestats/Q simgisaxs2D
		Do
			i+=1
		While (StringMatch(StringByKey("RECREATION", ImageInfo("","simgisaxs2d",0))[i,i], "," )==0)
		j=i
		Do
			j+=1
		While (StringMatch(StringByKey("RECREATION", ImageInfo("","simgisaxs2d",0))[j,j], "," )==0)
		VmaxCol=str2num(StringByKey("RECREATION", ImageInfo("","simgisaxs2d",0))[i+1,j-1])
		j=0
		Do
			j+=1
		While (StringMatch(StringByKey("RECREATION", ImageInfo("","simgisaxs2d",0))[j,j], "{" )==0)
		VminCol=str2num(StringByKey("RECREATION", ImageInfo("","simgisaxs2d",0))[j+1,i-1])
	Endif
	If (Numtype(VminCol)==2)
		VminCol=V_min
	Endif
	If (Numtype(VmaxCol)==2)
		VmaxCol=V_max
	Endif
	If (VminCol==0)
		VminCol=VmaxCol/100000
	Endif

	ModifyImage $imname ctab= {VminCol,VmaxCol,Geo,0}
	// ModifyImage $imname log=1
	// ColorScale/C/N=text0 log=1

	If (cmpstr(imname,"simgisaxs2D")==0)
		Button button6 disable=2
		Button button66 disable=0
	Else
		Button button6 disable=1
		Button button66 disable=0
	EndIf
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_symimage(ctrlName) : ButtonControl
	String ctrlName
	NVAR DirectX
	Wave/D gisaxs2D

	Variable Xmin1,Xmax1,Xmin2,Xmax2
	Xmax1=DirectX-1
	Xmin2=DirectX+1
	If (Dimsize(gisaxs2D,0)<=2*DirectX)
		Xmin1=2*DirectX-Dimsize(gisaxs2D,0)+1
		Xmax2=Dimsize(gisaxs2D,0)-1
	Else
		Xmin1=0
		Xmax2=2*DirectX
	Endif

	Duplicate/R=[Xmin1,Xmax1] gisaxs2D gisaxs2Dtemp1
	Duplicate/R=[Xmin2,Xmax2] gisaxs2D gisaxs2Dtemp2
	ImageRotate/O/H gisaxs2Dtemp1
	gisaxs2Dtemp2+=gisaxs2Dtemp1
	gisaxs2Dtemp1=gisaxs2Dtemp2
	gisaxs2D[Xmin2,Xmax2][]=gisaxs2Dtemp2[p-Xmin2][q]/2
	ImageRotate/O/H gisaxs2Dtemp1
	gisaxs2D[Xmin1,Xmax1][]=gisaxs2Dtemp1[p-Xmin1][q]/2

	Killwaves gisaxs2Dtemp1,gisaxs2Dtemp2

	Button button9 disable=2
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_reset(ctrlName) : ButtonControl
	String ctrlName
	NVAR VminCol, VmaxCol,DirectXinit,DirectYinit,DirectX,DirectY,ResolutionX,ResolutionY,varbinning
	
	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	DoWindow/K Guinier_plot

	Duplicate/O/D gisaxs2D_detec gisaxs2D
	Duplicate/O/D twothetaf_detec twothetaf
	Duplicate/O/D alphaf_detec alphaf

	WaveStats/Q gisaxs2D
	VminCol=0
	VmaxCol=abs(V_avg*10)

	ModifyImage gisaxs2D ctab= {VminCol,VmaxCol,Geo,0}
	ModifyGraph fSize=14,width=300,height={Plan,1,left,bottom},btLen=5,zero(bottom)=1
	// ModifyImage gisaxs2D log=0
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
	Label left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	SetAxis/A bottom
	SetAxis/A/E=1 left
	ColorScale/C/N=text0/X=0.00/Y=4.00/F=0/A=RC/E image=gisaxs2D,heightPct=100,width=10,lblMargin=-5,tickLen=5.00,fsize=14,log=0,prescaleExp=0,"Intensity (arb. units)"
	ModifyGraph width=0
	ShowInfo

	DirectX=DirectXinit
	DirectY=DirectYinit
	ResolutionX=ResolutionX/2^(varbinning)
	ResolutionY=ResolutionY/2^(varbinning)
	varbinning=0

	Print "New Image size =",DimSize(gisaxs2D,0),"x",DimSize(gisaxs2D,1),"(Resolution =",resolutionX,"x",resolutionY,"mm)"

	RemoveFromGraph/Z/W=NewGISAXS yPoints1,yPoints2
	Button button5 disable=0
	Button button5bis disable=0
	Button button6 disable=0
	Button button66 disable=1
	Button button9 disable=0
	Button button4bis disable=0
	Button button8 disable=0
	Button button8bis disable=1
	
	If (resolutionX==0.05503 || resolutionX==0.1)
		Button button5ter disable=0
	Endif
	
	WaveStats/Q gisaxs2D
	Slider slider0 limits={V_max*2,0,V_max/2e16}
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_nmscale(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,alphai_detec,rsmvar
	Wave/D twothetaf,alphaf
	
	twothetaf=2*pi/long_onde*sin(twothetaf*pi/180)
	alphaf=2*pi/long_onde*(sin(alphaf*pi/180)+sin(alphai_detec*pi/180))
	Label/W=NewGISAXS/Z bottom "q\\By\\M (nm\\S-1\\M)"
	Label/W=NewGISAXS/Z left "q\\Bz\\M (nm\\S-1\\M)"

	Wave/D simtwothetaf,simalphaf
	If (stringmatch(winlist("cut2d",";",""),"cut2d*")==1 || stringmatch(winlist("Fit_gisaxs2d",";",""),"Fit_gisaxs2d*")==1 || stringmatch(winlist("Res_gisaxs2d",";",""),"Res_gisaxs2d*")==1)
		simtwothetaf=2*pi/long_onde*sin(simtwothetaf*pi/180)
		simalphaf=2*pi/long_onde*(sin(simalphaf*pi/180)+sin(alphai_detec*pi/180))
	Endif
	If (stringmatch(winlist("cut2d",";",""),"cut2d*")==1)
		If (rsmvar!=1)
			Label/W=cut2d/Z bottom "q\\By\\M (nm\\S-1\\M)"
			Label/W=cut2d/Z left "q\\Bz\\M (nm\\S-1\\M)"
		Else
			Label/W=cut2d/Z bottom "q\\By\\M (nm\\S-1\\M)"
		Endif
	Endif
	If (stringmatch(winlist("Fit_gisaxs2d",";",""),"Fit_gisaxs2d*")==1)
		Label/W=Fit_gisaxs2d/Z bottom "q\\By\\M (nm\\S-1\\M)"
		Label/W=Fit_gisaxs2d/Z left "q\\Bz\\M (nm\\S-1\\M)"
	Endif
	If (stringmatch(winlist("Res_gisaxs2d",";",""),"Res_gisaxs2d*")==1)
		Label/W=Res_gisaxs2d/Z bottom "q\\By\\M (nm\\S-1\\M)"
		Label/W=Res_gisaxs2d/Z left "q\\Bz\\M (nm\\S-1\\M)"
	Endif
	
	Button button8 disable=1
	Button button8bis disable=0
	Button button5 disable=2
	Button button5bis disable=2
	Button button5ter disable=1

	DoWindow/K Fit2d_parameters
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_degscale(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,alphai_detec,rsmvar,resolutionX
	Wave/D twothetaf,alphaf
	
	twothetaf=asin(long_onde*twothetaf/2/pi)*180/pi
	alphaf=asin(long_onde*alphaf/2/pi-sin(alphai_detec*pi/180))*180/pi
	Label/W=NewGISAXS/Z bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
	Label/W=NewGISAXS/Z left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"

	Wave/D simtwothetaf,simalphaf
	
	If (stringmatch(winlist("cut2d",";",""),"cut2d*")==1 || stringmatch(winlist("Fit_gisaxs2d",";",""),"Fit_gisaxs2d*")==1 || stringmatch(winlist("Res_gisaxs2d",";",""),"Res_gisaxs2d*")==1)
		simtwothetaf=asin(long_onde*simtwothetaf/2/pi)*180/pi
		simalphaf=asin(long_onde*simalphaf/2/pi-sin(alphai_detec*pi/180))*180/pi
	Endif
	If (stringmatch(winlist("cut2d",";",""),"cut2d*")==1)
		If (rsmvar!=1)
			Label/W=cut2d/Z bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
			Label/W=cut2d/Z left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
		Else
			Label/W=cut2d/Z bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"
		Endif	
	Endif
	If (stringmatch(winlist("Fit_gisaxs2d",";",""),"Fit_gisaxs2d*")==1)
		Label/W=Fit_gisaxs2d/Z bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
		Label/W=Fit_gisaxs2d/Z left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	Endif
	If (stringmatch(winlist("Res_gisaxs2d",";",""),"Res_gisaxs2d*")==1)
		Label/W=Res_gisaxs2d/Z bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
		Label/W=Res_gisaxs2d/Z left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	Endif
	
	Button button8 disable=0
	Button button8bis disable=1
	Button button5 disable=0
	Button button5bis disable=0
	If (resolutionX==0.05503)
		Button button5ter disable=0
	Endif
	
	DoWindow/K Fit2d_parameters
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_binning(ctrlName) : ButtonControl
	String ctrlName
	NVAR DirectX,DirectY,ResolutionX,ResolutionY,varbinning
	Wave/D twothetaf,alphaf
	
	Button button5ter disable=1
	varbinning+=1
	
	Wave/D gisaxs2D

	Make/D/O/N=(dimsize(gisaxs2d,0)+2,dimsize(gisaxs2d,1)) gisaxstemp1,gisaxstemp2,gisaxstemp3,gisaxstemp4

	gisaxstemp1[2,dimsize(gisaxs2d,0)+1]=gisaxs2d[p-2][q]
	gisaxstemp2[1,dimsize(gisaxs2d,0)]=gisaxs2d[p-1][q]
	gisaxstemp3[0,dimsize(gisaxs2d,0)-1]=gisaxs2d[p][q]

	gisaxstemp4=(gisaxstemp1/2+gisaxstemp2+gisaxstemp3/2)/2

	DeletePoints 0,1, gisaxstemp4
	DeletePoints DimSize(gisaxs2d,0),1, gisaxstemp4

	gisaxstemp4[0]=gisaxstemp4[p][q]*4/3
	gisaxstemp4[DimSize(gisaxs2d,0)-1]=gisaxstemp4[p][q]*4/3

	If (DimSize(gisaxs2d,0)/2-Round(DimSize(gisaxs2d,0)/2)!=0)
		DeletePoints DimSize(gisaxs2d,0)-1,1, gisaxstemp4
		DeletePoints DimSize(gisaxs2d,0),1, twothetaf
	EndIf

	Make/D/O/N=(DimSize(gisaxs2d,0)/2,DimSize(gisaxs2d,1)) gisaxstemp5
	Make/D/O/N=(DimSize(gisaxstemp5,0)+1) twothetaftemp

	If (DirectX/2-Round(DirectX/2)!=0)
		gisaxstemp5[][]=gisaxstemp4[2*p+1][q]
		twothetaftemp=twothetaf[2*p+1]
	Else
		gisaxstemp5[][]=gisaxstemp4[2*p][q]
		twothetaftemp=twothetaf[2*p]
	EndIf

	Duplicate/O gisaxstemp5 gisaxs2d
	Duplicate/O twothetaftemp twothetaf
	KillWaves gisaxstemp1,gisaxstemp2,gisaxstemp3,gisaxstemp4,gisaxstemp5,twothetaftemp

/////////////

	Make/D/O/N=(DimSize(gisaxs2d,0),DimSize(gisaxs2d,1)+2) gisaxstemp1,gisaxstemp2,gisaxstemp3,gisaxstemp4

	gisaxstemp1[][2,DimSize(gisaxs2d,1)+1]=gisaxs2d[p][q-2]
	gisaxstemp2[][1,DimSize(gisaxs2d,1)]=gisaxs2d[p][q-1]
	gisaxstemp3[][0,DimSize(gisaxs2d,1)-1]=gisaxs2d[p][q]

	gisaxstemp4=(gisaxstemp1/2+gisaxstemp2+gisaxstemp3/2)/2

	DeletePoints/M=1 0,1, gisaxstemp4
	DeletePoints/M=1 DimSize(gisaxs2d,1),1, gisaxstemp4

	gisaxstemp4[][0]=gisaxstemp4[p][q]*4/3
	gisaxstemp4[][DimSize(gisaxs2d,1)-1]=gisaxstemp4[p][q]*4/3

	If (DimSize(gisaxs2d,1)/2-Round(DimSize(gisaxs2d,1)/2)!=0)
		DeletePoints/M=1 DimSize(gisaxs2d,1)-1,1, gisaxstemp4
		DeletePoints DimSize(gisaxs2d,1),1, alphaf
	EndIf

	Make/D/O/N=(DimSize(gisaxs2d,0),DimSize(gisaxs2d,1)/2) gisaxstemp5
	Make/D/O/N=(DimSize(gisaxstemp5,1)+1) alphaftemp

	If (DirectY/2-Round(DirectY/2)!=0)
		gisaxstemp5[][]=gisaxstemp4[p][2*q+1]
		alphaftemp=alphaf[2*p+1]
	Else
		gisaxstemp5[][]=gisaxstemp4[p][2*q]
		alphaftemp=alphaf[2*p]
	EndIf

	Duplicate/O gisaxstemp5 gisaxs2d
	Duplicate/O alphaftemp alphaf
	KillWaves gisaxstemp1,gisaxstemp2,gisaxstemp3,gisaxstemp4,gisaxstemp5,alphaftemp

	DirectX=Trunc(DirectX/2)
	DirectY=Trunc(DirectY/2)
	ResolutionX=ResolutionX*2
	ResolutionY=ResolutionY*2

	If (DimSize(gisaxs2D,0)<=5 || DimSize(gisaxs2D,1)<=5)
		Button button4bis disable=2
	EndIf
	
	Print "New Image size =",DimSize(gisaxs2D,0),"x",DimSize(gisaxs2D,1),"(Resolution =",resolutionX,"x",resolutionY,"mm)"
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_1dcut(ctrlName) : ButtonControl
	String ctrlName
	NVAR Vmincol,Vmaxcol,long_onde,resolutionX,distance,cut_pos,cut_angle,cut_width,alphai_detec,phi_detec
	Wave/D twothetaf,alphaf
	Variable pixelYdeb,pixelYfin,pixelZdeb,pixelZfin
	Variable i=1

	Variable cutpos=cut_pos
	Variable cutangle=cut_angle
	Variable cutwidth=cut_width
	Prompt cutpos,"Position (deg.):"
	Prompt cutangle,"Angle (deg.):"
	Prompt cutwidth,"Width (deg.):"
	DoPrompt "Enter parameters",cutangle,cutpos,cutwidth

	cut_angle=cutangle
	cut_pos=cutpos
	cut_width=cutwidth
	
	DoWindow/K cut
	DoWindow/K Guinier_plot
	RemoveFromGraph/W=NewGISAXS/Z yPoints1,yPoints2

	If (cut_angle==0)
		pixelYdeb=0
		pixelYfin=numpnts(twothetaf)-2
	
		WaveStats/Q alphaf
		If (cut_width>alphaf[V_npnts-2]-V_min)		// si larg > alphafmax-alphafmin, larg = alphafmax-alphafmin
			cut_width=alphaf[V_npnts-2]-V_min
		print cut_pos,cut_width
		EndIf
		If (cut_pos-cut_width/2<V_min)			// si pos - larg/2 < alphafmin, pos = alphafmin+larg/2
			cut_pos=V_min+cut_width/2
		print cut_pos,cut_width
		Endif
		If (cut_pos+cut_width/2>alphaf[V_npnts-2])	// si pos + larg/2 > alphafmax, pos = alphafmax-larg/2
			cut_pos=alphaf[V_npnts-2]-cut_width/2
		print cut_pos,cut_width
		Endif
		
		pixelZdeb=-1
		Do
			pixelZdeb=pixelZdeb+1
		While (alphaf[pixelZdeb]<cut_pos-cut_width/2)
		pixelZfin=pixelZdeb
		Do
			pixelZfin=pixelZfin+1
		While (alphaf[pixelZfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPoints1={twothetaf[pixelYdeb],twothetaf[pixelYfin]},yPoints1={alphaf[pixelZdeb],alphaf[pixelZdeb]},xPoints2={twothetaf[pixelYdeb],twothetaf[pixelYfin]},yPoints2={alphaf[pixelZfin],alphaf[pixelZfin]}
		AppendToGraph yPoints1 vs xPoints1
		AppendToGraph yPoints2 vs xPoints2
		
		Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX wavetwothetaf, wavealphaf, wavevector_x, wavevector_y, wavevector_z, wavevector, wavevector_xtemp, wavevector_ytemp
		Duplicate/O/D W_ImageLineProfile scatintensity
		wavetwothetaf=twothetaf
		wavealphaf=cut_pos
		wavevector_xtemp=2*pi/long_onde*(cos(wavetwothetaf*pi/180)*cos(wavealphaf*pi/180)-cos(alphai_detec*pi/180))
		wavevector_ytemp=2*pi/long_onde*(sin(wavetwothetaf*pi/180)*cos(wavealphaf*pi/180))
		wavevector_x=wavevector_xtemp*cos(phi_detec*pi/180)+wavevector_ytemp*sin(phi_detec*pi/180)
		wavevector_y=-wavevector_xtemp*sin(phi_detec*pi/180)+wavevector_ytemp*cos(phi_detec*pi/180)
		wavevector_z=2*pi/long_onde*(sin(wavealphaf*pi/180)+sin(alphai_detec*pi/180))
		wavevector=x

		Do
			pixelZdeb=pixelZdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity=scatintensity+profiletemp
			i=i+1
		While (pixelZdeb<pixelZfin-1)

		scatintensity=scatintensity/i
		Print "Horizontal cut at alphaf =",cut_pos,"deg. averaged on",i,"pixels ( [",pixelZfin-i,"]",alphaf[pixelZfin-i],"-> [",pixelZfin-1,"]",alphaf[pixelZfin-1],")"

	ElseIf (cut_angle==90)
		pixelZdeb=0
		pixelZfin=numpnts(alphaf)-2

		WaveStats/Q twothetaf
		If (cut_width>twothetaf[V_npnts-2]-V_min)		// si larg > twothetafmax-twothetafmin, larg = twothetafmax-twothetafmin
			cut_width=twothetaf[V_npnts-2]-V_min
		EndIf
		If (cut_pos-cut_width/2<V_min)			// si pos - larg/2 < twothetafmin, pos = twothetafmin+larg/2
			cut_pos=V_min+cut_width/2
		Endif
		If (cut_pos+cut_width/2>twothetaf[V_npnts-2])	// si pos + larg/2 < twothetafmax, pos = twothetafmax-larg/2
			cut_pos=twothetaf[V_npnts-2]-cut_width/2
		Endif
		
		pixelYdeb=-1
		Do
			pixelYdeb=pixelYdeb+1
		While (twothetaf[pixelYdeb]<cut_pos-cut_width/2)
		pixelYfin=pixelYdeb
		Do
			pixelYfin=pixelYfin+1
		While (twothetaf[pixelYfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPoints1={twothetaf[pixelYdeb],twothetaf[pixelYdeb]},yPoints1={alphaf[pixelZdeb],alphaf[pixelZfin]},xPoints2={twothetaf[pixelYfin],twothetaf[pixelYfin]},yPoints2={alphaf[pixelZdeb],alphaf[pixelZfin]}
		AppendToGraph yPoints1 vs xPoints1
		AppendToGraph yPoints2 vs xPoints2

		Make/O/N=2 xPixel={pixelYdeb,pixelYdeb},yPixel={pixelZdeb,pixelZfin}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX wavetwothetaf, wavealphaf, wavevector_x, wavevector_y, wavevector_z, wavevector, wavevector_xtemp, wavevector_ytemp
		Duplicate/O/D W_ImageLineProfile scatintensity
		wavetwothetaf=cut_pos
		wavealphaf=alphaf
		wavevector_xtemp=2*pi/long_onde*(cos(wavetwothetaf*pi/180)*cos(wavealphaf*pi/180)-cos(alphai_detec*pi/180))
		wavevector_ytemp=2*pi/long_onde*(sin(wavetwothetaf*pi/180)*cos(wavealphaf*pi/180))
		wavevector_x=wavevector_xtemp*cos(phi_detec*pi/180)+wavevector_ytemp*sin(phi_detec*pi/180)
		wavevector_y=-wavevector_xtemp*sin(phi_detec*pi/180)+wavevector_ytemp*cos(phi_detec*pi/180)
		wavevector_z=2*pi/long_onde*(sin(wavealphaf*pi/180)+sin(alphai_detec*pi/180))
		wavevector=x

		Do
			pixelYdeb=pixelYdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYdeb},yPixel={pixelZdeb,pixelZfin}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity=scatintensity+profiletemp
			i=i+1
		While (pixelYdeb<pixelYfin-1)

		scatintensity=scatintensity/i
		Print "Vertical cut at twothetaf =",cut_pos,"deg. averaged on",i,"pixels ( [",pixelYfin-i,"]",twothetaf[pixelYfin-i],"-> [",pixelYfin-1,"]",twothetaf[pixelYfin-1],")"

	Else
		cut_pos=0
		If (cut_width>90)				// si larg > 90, larg = 90
			cut_width=90
		EndIf
		If (cut_angle-cut_width/2<0)		// si angle - larg/2 < 0, angle = larg/2
			cut_angle=cut_width/2
		Endif
		If (cut_angle+cut_width/2>90)		// si angle + larg/2 > 90, angle = 90-larg/2
			cut_angle=90-cut_width/2
		Endif

		WaveStats/Q alphaf
		Variable alphafmaximum=V_max
		WaveStats/Q twothetaf
		Variable anglemoins=abs(atan(alphafmaximum/V_min)*180/pi)
		Variable angleplus=atan(alphafmaximum/V_max)*180/pi
		Variable twothetaf1,alphaf1,twothetaf2,alphaf2
				
		If (angleplus>cut_angle-cut_width/2)
			twothetaf1=V_max
			alphaf1=V_max*tan((cut_angle-cut_width/2)*pi/180)
		Else
			twothetaf1=alphafmaximum/tan((cut_angle-cut_width/2)*pi/180)
			alphaf1=alphafmaximum
		Endif
		If (angleplus>cut_angle+cut_width/2)
			twothetaf2=V_max
			alphaf2=V_max*tan((cut_angle+cut_width/2)*pi/180)
		Else
			twothetaf2=alphafmaximum/tan((cut_angle+cut_width/2)*pi/180)
			alphaf2=alphafmaximum
		Endif

		Make/O/N=3 xPoints1={twothetaf1,0,twothetaf2},yPoints1={alphaf1,0,alphaf2}

		If (anglemoins>cut_angle-cut_width/2)
			twothetaf1=V_min
			alphaf1=abs(V_min)*tan((cut_angle-cut_width/2)*pi/180)
		Else
			twothetaf1=-alphafmaximum/tan((cut_angle-cut_width/2)*pi/180)
			alphaf1=alphafmaximum
		Endif
		If (anglemoins>cut_angle+cut_width/2)
			twothetaf2=V_min
			alphaf2=abs(V_min)*tan((cut_angle+cut_width/2)*pi/180)
		Else
			twothetaf2=-alphafmaximum/tan((cut_angle+cut_width/2)*pi/180)
			alphaf2=alphafmaximum
		Endif

		Make/O/N=3 xPoints2={twothetaf1,0,twothetaf2},yPoints2={alphaf1,0,alphaf2}

		AppendToGraph yPoints1 vs xPoints1
		AppendToGraph yPoints2 vs xPoints2

		Duplicate/O/D gisaxs2D tempx,tempy,tempimage,tempradius,tempangle,tempsector
		tempx=twothetaf[x]
		tempy=alphaf[y]
		tempradius=sign(tempx)*sqrt((tempx)^2+(tempy)^2)
		tempangle=sign(tempx)*atan(tempy/tempx)*180/pi
		tempsector=-abs(sign(tempangle-cut_angle+cut_width/2)+sign(tempangle-cut_angle-cut_width/2))/2+1
		tempimage=tempimage*tempsector
		Redimension/N=(DimSize(gisaxs2D,0)*DimSize(gisaxs2D,1)) tempimage,tempsector,tempradius

		Variable pas=(2*pi/long_onde)*sin(atan(resolutionX/distance))
		Wavestats/Q tempradius
		Make/O/N=((V_max-V_min)/pas+1)/D radial0,wavevector,scatintensity
		SetScale/P x V_min,pas," ", radial0,wavevector,scatintensity
		radial0=0
		wavevector=x
		scatintensity=0
		For(i=0;i<numpnts(tempradius);i+=1)
			scatintensity[round((tempradius[i]-V_min)/pas)]+=tempimage[i]
			radial0[round((tempradius[i]-V_min)/pas)]+=tempsector[i]
		Endfor
		scatintensity=scatintensity/radial0
		For(i=numpnts(wavevector);i>0;i-=1)
			If (radial0[i-1]==0)
				DeletePoints i-1,1, scatintensity,wavevector,radial0
			Endif
		Endfor

		Duplicate/O/D wavevector wavetwothetaf, wavealphaf, wavevector_x, wavevector_y, wavevector_z, wavevector_xtemp, wavevector_ytemp
		wavetwothetaf=wavevector*cos(cut_angle*pi/180)
		wavealphaf=wavevector*sin(cut_angle*pi/180)*sign(wavevector)
		wavevector_xtemp=2*pi/long_onde*(cos(wavetwothetaf*pi/180)*cos(wavealphaf*pi/180)-cos(alphai_detec*pi/180))
		wavevector_ytemp=2*pi/long_onde*(sin(wavetwothetaf*pi/180)*cos(wavealphaf*pi/180))
		wavevector_x=wavevector_xtemp*cos(phi_detec*pi/180)+wavevector_ytemp*sin(phi_detec*pi/180)
		wavevector_y=-wavevector_xtemp*sin(phi_detec*pi/180)+wavevector_ytemp*cos(phi_detec*pi/180)
		wavevector_z=2*pi/long_onde*(sin(wavealphaf*pi/180)+sin(alphai_detec*pi/180))

		Wavestats/Q radial0
		Print "Sector cut averaged on",V_avg,"pixels"
	
		SetScale/P x 0,1,"", scatintensity,wavevector
		wavevector=x	
	Endif

	Display/W=(480, 10, 880, 240) scatintensity vs wavevector	// /W=(left, top, right, bottom )
	ModifyGraph mirror=2, btLen=5, fSize=14, zero(bottom)=1
	Label bottom "Pixel"
	Label left "Intensity (arb. units)"
	SetAxis left Vmincol,Vmaxcol
	ShowInfo
	ControlBar 30
	Button intens0 title="Guinier", proc=ButtonProc_guinierplot, pos={380,5}, size={60,20},fsize=11,disable=2
	Button intens1 title="Peak position", proc=ButtonProc_peakposition, pos={295,5}, size={75,20},fsize=11
	Button intens21 title="Lin. scale", proc=ButtonProc_linscale1d, pos={155,5}, size={60,20},fsize=11, disable=1
	Button intens22 title="Log. scale", proc=ButtonProc_logscale1d, pos={155,5}, size={60,20},fsize=11
	Button intens3 title="Autoscale", proc=ButtonProc_autoscale, pos={85,5}, size={60,20},fsize=11
	Button intens6 title="1D fit", proc=ButtonProc_fit1D, pos={225,5}, size={60,20},fsize=11
	Button intens5 title="Rename", proc=ButtonProc_renamewavecut, pos={450,5}, size={60,20},fsize=11

	PopupMenu popup0 proc=PopMenuProc,pos={20,5},bodyWidth=65,value="Pixel;qx;qy;qz;2thetaf;alphaf"

	DoWindow/C cut

	Killwaves/Z profiletemp,xPixel,yPixel,W_LineProfileX,W_LineProfileY,W_ImageLineProfile,tempx,tempy,tempimage,tempradius,tempangle,tempsector,radial0,wavevector_xtemp,wavevector_ytemp,wavevector_ztemp
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	NVAR cursmin,cursmax
	Wave/D wavevector,wavevector_x,wavevector_y,wavevector_z,wavetwothetaf,wavealphaf,fit_wavevector
	
	RemoveFromGraph/Z fit_peakposition
	DoWindow/K Fit1d_parameters
	
	If (popnum==1)
		wavevector=x	
		Label bottom "Pixel"
		Button intens0 disable=2
		Button intens6 disable=0
	ElseIf (popnum==2)
		wavevector=wavevector_x
		Label bottom "q\\Bx\\M (nm\\S-1\\M)"
		Button intens0 disable=0
		Button intens6 disable=2
	ElseIf (popnum==3)
		wavevector=wavevector_y
		Label bottom "q\\By\\M (nm\\S-1\\M)"
		Button intens0 disable=0
		Button intens6 disable=2
	ElseIf (popnum==4)
		wavevector=wavevector_z
		Label bottom "q\\Bz\\M (nm\\S-1\\M)"
		Button intens0 disable=0
		Button intens6 disable=2
	ElseIf (popnum==5)
		wavevector=wavetwothetaf
		Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
		Button intens0 disable=2
		Button intens6 disable=2
	ElseIf (popnum==6)
		wavevector=wavealphaf
		Label bottom "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"	
		Button intens0 disable=2
		Button intens6 disable=2
	Endif
	
	Duplicate/O/D/R=[cursmin,cursmax] wavevector fit_wavevector
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_2dcut(ctrlName) : ButtonControl
	String ctrlName
	NVAR Vmincol,Vmaxcol,long_onde,alphai_detec,phi_detec
	Variable/G rsmvar=0
	Wave/D twothetaf,alphaf
	Variable ymin,ymax,zmin,zmax

	DoWindow/K cut2d
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	RemoveFromGraph/W=NewGISAXS/Z yPoints1,yPoints2
	Killwaves/Z Fit_scatintensity2D,Res_scatintensity2D,simgisaxs2D

	If (numtype(str2num(StringByKey("point", CsrInfo(A))))==2)		// si le curseur A n'existe pas sur le graph
		Abort "Cursor A is not present on the graph !"
	Endif
	If (numtype(str2num(StringByKey("point", CsrInfo(B))))==2)		// si le curseur B n'existe pas sur le graph
		Abort "Cursor B is not present on the graph !"
	Endif

	ymin=str2num(StringByKey("point", CsrInfo(A)))
	zmin=str2num(StringByKey("ypoint", CsrInfo(A)))
	ymax=str2num(StringByKey("point", CsrInfo(B)))
	zmax=str2num(StringByKey("ypoint", CsrInfo(B)))

	Make/O/N=5 xPoints1={twothetaf[ymin],twothetaf[ymax],twothetaf[ymax],twothetaf[ymin],twothetaf[ymin]},yPoints1={alphaf[zmin],alphaf[zmin],alphaf[zmax],alphaf[zmax],alphaf[zmin]}
	AppendToGraph yPoints1 vs xPoints1

	Duplicate/O/D/R=[ymin,ymax+1] twothetaf simtwothetaf
	Duplicate/O/D/R=[zmin,zmax+1] alphaf simalphaf
	Duplicate/O/D/R=[ymin,ymax][zmin,zmax] gisaxs2D scatintensity2D, wavevector_xtemp, wavevector_ytemp, wavevector_x2D, wavevector_y2D, wavevector_z2D
	
	wavevector_xtemp[][]=2*pi/long_onde*(cos(simtwothetaf[p]*pi/180)*cos(simalphaf[q]*pi/180)-cos(alphai_detec*pi/180))
	wavevector_ytemp[][]=2*pi/long_onde*(sin(simtwothetaf[p]*pi/180)*cos(simalphaf[q]*pi/180))
	wavevector_x2D[][]=wavevector_xtemp*cos(phi_detec*pi/180)+wavevector_ytemp*sin(phi_detec*pi/180)
	wavevector_y2D[][]=-wavevector_xtemp*sin(phi_detec*pi/180)+wavevector_ytemp*cos(phi_detec*pi/180)


	wavevector_z2D[][]=2*pi/long_onde*(sin(simalphaf[q]*pi/180)+sin(alphai_detec*pi/180))

	KillWaves wavevector_xtemp, wavevector_ytemp	
	
	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity2D vs {simtwothetaf,simalphaf}
	ModifyImage scatintensity2D ctab= {VminCol,VmaxCol,Geo,0}
	ModifyGraph width=200, height={Plan,1,left,bottom},fSize=10,btLen=3,zero(bottom)=1
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"	
	Label left "\\F'Symbol'a\\F'Arial'\\Bf\\M (deg)"
	DoWindow/C cut2d

	Print "2D cut from {",ymin,",",zmin,"} to {",ymax,",",zmax,"}"
	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(2)
	DoWindow/C Fit2d_parameters
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_RSMid01(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,cut_pos,cut_width,alphai_detec,phi_detec
	Variable/G rsmvar=1
	Wave/D twothetaf,alphaf,gisaxs2d
	String chemin, nombin
	String ask="no"
	Variable xdim,ydim
	Variable pixelYdeb,pixelYfin,pixelZdeb,pixelZfin
	Variable i,j,firstimage,phimin,phimax
	phimin=0
	phimax=90
	
	Prompt phimin,"Azimuthal angle min. (deg.):"
	Prompt phimax,"Azimuthal angle max. (deg.):"
	Prompt ask, "Create video:", popup "yes;no;"
	DoPrompt "Enter parameters",phimin,phimax,ask
	
	DoWindow/K cut2d
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Fit_scatintensity2D,Res_scatintensity2D,simgisaxs2D

	Make/O/N=(numpnts(twothetaf)-1,phimax-phimin+1)/D scatintensity2D
	Make/O/N=(phimax-phimin+2)/D phif
	phif=x+phimin-0.5

	Duplicate/O/D scatintensity2D simtwothetaf,simalphaf,simphif,wavevector_xtemp, wavevector_ytemp, wavevector_x2D, wavevector_y2D, wavevector_z2D
	simtwothetaf[][]=twothetaf[p]
	simalphaf=cut_pos
	simphif=y+phimin
	
	wavevector_xtemp[][]=2*pi/long_onde*(cos(simtwothetaf*pi/180)*cos(simalphaf*pi/180)-cos(alphai_detec*pi/180))
	wavevector_ytemp[][]=2*pi/long_onde*(sin(simtwothetaf*pi/180)*cos(simalphaf*pi/180))
	wavevector_x2D[][]=wavevector_xtemp*cos(simphif*pi/180)+wavevector_ytemp*sin(simphif*pi/180)
	wavevector_y2D[][]=-wavevector_xtemp*sin(simphif*pi/180)+wavevector_ytemp*cos(simphif*pi/180)
	wavevector_z2D[][]=2*pi/long_onde*(sin(simalphaf*pi/180)+sin(alphai_detec*pi/180))
	
	Duplicate/O/D twothetaf simtwothetaf

	KillWaves wavevector_xtemp, wavevector_ytemp	
	
	LoadWave/A=source/B="F=-2;"/J/Q
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	
	firstimage=str2num(nombin[strlen(nombin)-7,strlen(nombin)-4])

	String spectramoviename="GISAXSmovie"
	String s

	If (cmpstr(ask,"yes")==0) 
		NewMovie/F=10/L/O/P=chemin/Z as spectramoviename
	Endif

	For(j=0;j<phimax-phimin+1;j+=1)
		print "Azimuthal angle =",j+phimin,"deg.",nombin
		phi_detec=j+phimin

		//----------------------load------------------------------------------------------------------------------------------------------------------------------------------

		xdim=1242
		ydim=1152

		GBLoadWave/A=source/P=chemin/T={2,4}/S=8192/W=1/B/Q nombin
		Redimension/N=(xdim,ydim) source1
		Duplicate/O/D source1 gisaxs2D0
		Reverse/P gisaxs2D0
		gisaxs2D=gisaxs2D0
		Killwaves source1,gisaxs2D0

		If (cmpstr(ask,"yes")==0) 
			SetDrawEnv fsize=16,textrgb=(65535,65535,65535)
			sprintf s,"\\F'Symbol'j\\F'Arial' = %2.0f"+" deg", phi_detec
			DrawText 0.65,0.18,s
			SetDrawLayer UserFront

			DoUpdate

			AddMovieFrame
			SetDrawLayer/K UserFront
		Else
			DoUpdate
		Endif

		//----------------------cut------------------------------------------------------------------------------------------------------------------------------------------
		i=1
		pixelYdeb=0
		pixelYfin=numpnts(twothetaf)-2
		pixelZdeb=-1
		Do
			pixelZdeb=pixelZdeb+1
		While (alphaf[pixelZdeb]<cut_pos-cut_width/2)
		pixelZfin=pixelZdeb
		Do
			pixelZfin=pixelZfin+1
		While (alphaf[pixelZfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX  wavevector0 
		Duplicate/O/D W_ImageLineProfile scatintensity0
		wavevector0=x

		Do
			pixelZdeb=pixelZdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity0=scatintensity0+profiletemp
			i=i+1
		While (pixelZdeb<pixelZfin-1)

		scatintensity0=scatintensity0/i

		Killwaves/Z profiletemp,xPixel,yPixel,W_LineProfileX,W_LineProfileY,W_ImageLineProfile,tempx,tempy,tempimage,tempradius,tempangle,tempsector,radial0

		scatintensity2D[][j]=scatintensity0[p]
		
		If ((j+firstimage)<9)
			nombin=nombin[0,strlen(nombin)-5]+num2str(j+firstimage+1)+"ccd"
		Elseif ((j+firstimage)<99)
			nombin=nombin[0,strlen(nombin)-6]+num2str(j+firstimage+1)+"ccd"
		Else
			nombin=nombin[0,strlen(nombin)-7]+num2str(j+firstimage+1)+"ccd"
		Endif
	Endfor
	
	If (cmpstr(ask,"yes")==0) 
		CloseMovie
		Print "GISAXS movie has been created"
	Endif

	//----------------------display image------------------------------------------------------------------------------------------------------------------------------------------

	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity2D vs {twothetaf,phif}
	ModifyImage scatintensity2D ctab= {*,*,Geo,0}
	ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
	Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"
	DoWindow/C cut2d
	
	Killwaves source0
	phi_detec=phimin

	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(2)
	DoWindow/C Fit2d_parameters
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_RSMd2am(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,cut_pos,cut_width,alphai_detec,phi_detec
	Variable/G rsmvar=1
	Wave/D twothetaf,alphaf,gisaxs2d
	String chemin, nombin
	String ask="no"
	Variable xdim,ydim
	Variable pixelYdeb,pixelYfin,pixelZdeb,pixelZfin
	Variable i,j,firstimage,phimin,phimax
	phimin=0
	phimax=90
	
	Prompt phimin,"Azimuthal angle min. (deg.):"
	Prompt phimax,"Azimuthal angle max. (deg.):"
	Prompt ask, "Create video:", popup "yes;no;"
	DoPrompt "Enter parameters",phimin,phimax,ask
	
	DoWindow/K cut2d
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Fit_scatintensity2D,Res_scatintensity2D,simgisaxs2D

	Make/O/N=(numpnts(twothetaf)-1,phimax-phimin+1)/D scatintensity2D
	Make/O/N=(phimax-phimin+2)/D phif
	phif=x+phimin-0.5

	Duplicate/O/D scatintensity2D simtwothetaf,simalphaf,simphif,wavevector_xtemp, wavevector_ytemp, wavevector_x2D, wavevector_y2D, wavevector_z2D
	simtwothetaf[][]=twothetaf[p]
	simalphaf=cut_pos
	simphif=y+phimin
	
	wavevector_xtemp[][]=2*pi/long_onde*(cos(simtwothetaf*pi/180)*cos(simalphaf*pi/180)-cos(alphai_detec*pi/180))
	wavevector_ytemp[][]=2*pi/long_onde*(sin(simtwothetaf*pi/180)*cos(simalphaf*pi/180))
	wavevector_x2D[][]=wavevector_xtemp*cos(simphif*pi/180)+wavevector_ytemp*sin(simphif*pi/180)
	wavevector_y2D[][]=-wavevector_xtemp*sin(simphif*pi/180)+wavevector_ytemp*cos(simphif*pi/180)
	wavevector_z2D[][]=2*pi/long_onde*(sin(simalphaf*pi/180)+sin(alphai_detec*pi/180))
	
	Duplicate/O/D twothetaf simtwothetaf

	KillWaves wavevector_xtemp, wavevector_ytemp	
	
	LoadWave/A=source/B="F=-2;"/J/Q
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]

	String manip="sep2010"		// sep2010, dec2010, sep2011
	Variable startnumber
	String extensionfile
	If (cmpstr(manip,"sep2010")==0)
		startnumber=6
		extensionfile="DGF_EDF"
	ElseIf (cmpstr(manip,"dec2010")==0)
		startnumber=3
		extensionfile="_EDF"
	Elseif (cmpstr(manip,"sep2011")==0)
		startnumber=2
		extensionfile="dgf.edf"
	Endif

	firstimage=str2num(nombin[startnumber,startnumber+2])

	String spectramoviename="GISAXSmovie"
	String s

	If (cmpstr(ask,"yes")==0) 
		NewMovie/F=10/L/O/P=chemin/Z as spectramoviename
	Endif

	For(j=0;j<phimax-phimin+1;j+=1)
		print "Azimuthal angle =",j+phimin,"deg.",nombin
		phi_detec=j+phimin

		//----------------------load------------------------------------------------------------------------------------------------------------------------------------------

		xdim=dimsize(gisaxs2d,0)
		ydim=dimsize(gisaxs2d,1)

		GBLoadWave/A=source/P=chemin/T={32,4}/S=1024/W=1/F=1/B=1/Q nombin
		Redimension/N=(xdim,ydim) source1
		Duplicate/O/D source1 gisaxs2D0
		Reverse/dim=1/P gisaxs2D0
		gisaxs2D=gisaxs2D0
		Killwaves source1,gisaxs2D0

		If (cmpstr(ask,"yes")==0) 
			SetDrawEnv fsize=16,textrgb=(65535,65535,65535)
			sprintf s,"\\F'Symbol'j\\F'Arial' = %2.0f"+" deg", phi_detec
			DrawText 0.65,0.18,s
			SetDrawLayer UserFront

			DoUpdate

			AddMovieFrame
			SetDrawLayer/K UserFront
		Else
			DoUpdate
		Endif

		//----------------------cut------------------------------------------------------------------------------------------------------------------------------------------
		i=1
		pixelYdeb=0
		pixelYfin=numpnts(twothetaf)-2
		pixelZdeb=-1
		Do
			pixelZdeb=pixelZdeb+1
		While (alphaf[pixelZdeb]<cut_pos-cut_width/2)
		pixelZfin=pixelZdeb
		Do
			pixelZfin=pixelZfin+1
		While (alphaf[pixelZfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX  wavevector0 
		Duplicate/O/D W_ImageLineProfile scatintensity0
		wavevector0=x

		Do
			pixelZdeb=pixelZdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity0=scatintensity0+profiletemp
			i=i+1
		While (pixelZdeb<pixelZfin-1)

		scatintensity0=scatintensity0/i

		Killwaves/Z profiletemp,xPixel,yPixel,W_LineProfileX,W_LineProfileY,W_ImageLineProfile,tempx,tempy,tempimage,tempradius,tempangle,tempsector,radial0

		scatintensity2D[][j]=scatintensity0[p]
		
		nombin=s_filename[0,startnumber-1]+num2str(j+firstimage+1)+extensionfile
	Endfor

	If (cmpstr(ask,"yes")==0) 
		CloseMovie
		Print "GISAXS movie has been created"
	Endif

	//----------------------display image------------------------------------------------------------------------------------------------------------------------------------------

	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity2D vs {twothetaf,phif}
	ModifyImage scatintensity2D ctab= {*,*,Geo,0}
	ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
	Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"
	DoWindow/C cut2d
	
	Killwaves source0
	phi_detec=phimin

	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(2)
	DoWindow/C Fit2d_parameters
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_RSMd2amxpad(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,cut_pos,cut_width,alphai_detec,phi_detec,Vmincol,Vmaxcol
	Variable/G rsmvar=1
	Wave/D twothetaf,alphaf,gisaxs2d
	String chemin, nombin
	String ask="no"
	Variable xdim,ydim
	Variable pixelYdeb,pixelYfin,pixelZdeb,pixelZfin
	Variable i,j,firstimage,phimin,phimax,phistep
	phimin=-10
	phimax=10
	phistep=0.05
	
	Prompt phimin,"Azimuthal angle min. (deg.):"
	Prompt phimax,"Azimuthal angle max. (deg.):"
	Prompt phistep,"Azimuthal step (deg.):"
	Prompt ask, "Create video:", popup "yes;no;"
	DoPrompt "Enter parameters",phimin,phimax,phistep,ask
	
	DoWindow/K cut2d
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Fit_scatintensity2D,Res_scatintensity2D,simgisaxs2D

	Make/O/N=(numpnts(twothetaf)-1,(phimax-phimin)/phistep+1)/D scatintensity2D
	Make/O/N=((phimax-phimin)/phistep+2)/D phif
	phif=x*phistep+phimin-0.5*phistep

	Duplicate/O/D scatintensity2D simtwothetaf,simalphaf,simphif,wavevector_xtemp, wavevector_ytemp, wavevector_x2D, wavevector_y2D, wavevector_z2D
	simtwothetaf[][]=twothetaf[p]
	simalphaf=cut_pos
	simphif=y*phistep+phimin
	
	wavevector_xtemp[][]=2*pi/long_onde*(cos(simtwothetaf*pi/180)*cos(simalphaf*pi/180)-cos(alphai_detec*pi/180))
	wavevector_ytemp[][]=2*pi/long_onde*(sin(simtwothetaf*pi/180)*cos(simalphaf*pi/180))
	wavevector_x2D[][]=wavevector_xtemp*cos(simphif*pi/180)+wavevector_ytemp*sin(simphif*pi/180)
	wavevector_y2D[][]=-wavevector_xtemp*sin(simphif*pi/180)+wavevector_ytemp*cos(simphif*pi/180)
	wavevector_z2D[][]=2*pi/long_onde*(sin(simalphaf*pi/180)+sin(alphai_detec*pi/180))
	
	Duplicate/O/D twothetaf simtwothetaf

	KillWaves wavevector_xtemp, wavevector_ytemp	
	
	LoadWave/A=source/B="F=-2;"/J/Q
	Wave/T source0
	Variable byteorder
	String bytetemp=source0[2]
	bytetemp=bytetemp[13,15]
	If (cmpstr(bytetemp,"Low")==0)
		byteorder=1
	Else
		byteorder=0
	Endif
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	
	firstimage=str2num(nombin[8,10])	// manips sept2012
	
	String spectramoviename="GISAXSmovie"
	String s

	If (cmpstr(ask,"yes")==0) 
		NewMovie/F=10/L/O/P=chemin/Z as spectramoviename
	Endif

	For(j=0;j<(phimax-phimin)/phistep+1;j+=1)
		print "Azimuthal angle =",j*phistep+phimin,"deg.",nombin
		phi_detec=j*phistep+phimin

		//----------------------load------------------------------------------------------------------------------------------------------------------------------------------

		xdim=dimsize(gisaxs2d,0)
		ydim=dimsize(gisaxs2d,1)
		
		GBLoadWave/A=source/P=chemin/T={2,4}/S=512/W=1/B=(byteorder) nombin
		If (ydim > xdim)
			Redimension/N=(xdim,ydim) source1
			Duplicate/O/D source1 gisaxs2D0
		Else
			Redimension/N=(ydim,xdim) source1
			Duplicate/O/D source1 gisaxs2D0
			MatrixTranspose gisaxs2D0
		Endif
		gisaxs2D=gisaxs2D0
		Killwaves source1,gisaxs2D0

		If (cmpstr(ask,"yes")==0) 
			SetDrawEnv fsize=16,textrgb=(65535,65535,65535)
			sprintf s,"\\F'Symbol'j\\F'Arial' = %2.0f"+" deg", phi_detec
			DrawText 0.65,0.18,s
			SetDrawLayer UserFront

			DoUpdate

			AddMovieFrame
			SetDrawLayer/K UserFront
		Else
			DoUpdate
		Endif

		//----------------------cut------------------------------------------------------------------------------------------------------------------------------------------
		i=1
		pixelYdeb=0
		pixelYfin=numpnts(twothetaf)-2
		pixelZdeb=-1
		Do
			pixelZdeb=pixelZdeb+1
		While (alphaf[pixelZdeb]<cut_pos-cut_width/2)
		pixelZfin=pixelZdeb
		Do
			pixelZfin=pixelZfin+1
		While (alphaf[pixelZfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX  wavevector0 
		Duplicate/O/D W_ImageLineProfile scatintensity0
		wavevector0=x

		Do
			pixelZdeb=pixelZdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity0=scatintensity0+profiletemp
			i=i+1
		While (pixelZdeb<pixelZfin-1)

		scatintensity0=scatintensity0/i

		Killwaves/Z profiletemp,xPixel,yPixel,W_LineProfileX,W_LineProfileY,W_ImageLineProfile,tempx,tempy,tempimage,tempradius,tempangle,tempsector,radial0

		scatintensity2D[][j]=scatintensity0[p]
		
		nombin=s_filename[0,7]+num2str(j+firstimage+1)+"g.edf"		// manips sept2012

	Endfor

	If (cmpstr(ask,"yes")==0) 
		CloseMovie
		Print "GISAXS movie has been created"
	Endif

	//----------------------display image------------------------------------------------------------------------------------------------------------------------------------------

	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity2D vs {twothetaf,phif}
	ModifyImage scatintensity2D ctab= {Vmincol,Vmaxcol,Geo,0}
	ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
	Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"
	DoWindow/C cut2d
	
	Killwaves source0
	phi_detec=phimin

	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(2)
	DoWindow/C Fit2d_parameters
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_RSMsixs(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,cut_pos,cut_width,alphai_detec,phi_detec
	Variable/G rsmvar=1
	Wave/D twothetaf,alphaf,gisaxs2d
	String chemin, nombin
	String ask="no"
	Variable xdim,ydim
	Variable pixelYdeb,pixelYfin,pixelZdeb,pixelZfin
	Variable i,j,firstimage,phimin,phimax
	phimin=0
	phimax=90
	
	Prompt phimin,"Azimuthal angle min. (deg.):"
	Prompt phimax,"Azimuthal angle max. (deg.):"
	Prompt ask, "Create video:", popup "yes;no;"
	DoPrompt "Enter parameters",phimin,phimax,ask
	
	DoWindow/K cut2d
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Fit_scatintensity2D,Res_scatintensity2D,simgisaxs2D

	Make/O/N=(numpnts(twothetaf)-1,phimax-phimin+1)/D scatintensity2D
	Make/O/N=(phimax-phimin+2)/D phif
	phif=x+phimin-0.5

	Duplicate/O/D scatintensity2D simtwothetaf,simalphaf,simphif,wavevector_xtemp, wavevector_ytemp, wavevector_x2D, wavevector_y2D, wavevector_z2D
	simtwothetaf[][]=twothetaf[p]
	simalphaf=cut_pos
	simphif=y+phimin
	
	wavevector_xtemp[][]=2*pi/long_onde*(cos(simtwothetaf*pi/180)*cos(simalphaf*pi/180)-cos(alphai_detec*pi/180))
	wavevector_ytemp[][]=2*pi/long_onde*(sin(simtwothetaf*pi/180)*cos(simalphaf*pi/180))
	wavevector_x2D[][]=wavevector_xtemp*cos(simphif*pi/180)+wavevector_ytemp*sin(simphif*pi/180)
	wavevector_y2D[][]=-wavevector_xtemp*sin(simphif*pi/180)+wavevector_ytemp*cos(simphif*pi/180)
	wavevector_z2D[][]=2*pi/long_onde*(sin(simalphaf*pi/180)+sin(alphai_detec*pi/180))
	
	Duplicate/O/D twothetaf simtwothetaf

	KillWaves wavevector_xtemp, wavevector_ytemp	
	
	LoadWave/A=source/B="F=-2;"/J/Q
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]

	String nombintemp=nombin[0,strlen(nombin)-5]
	i=0
	Do
		i+=1
	While (numtype(str2num(nombintemp[strlen(nombintemp)-i,strlen(nombintemp)]))==0)

	firstimage=str2num(nombintemp[strlen(nombintemp)-i+1,strlen(nombintemp)])
	nombintemp=nombintemp[0,strlen(nombintemp)-strlen(num2str(firstimage))-1]
	print firstimage,nombintemp

	String spectramoviename="GISAXSmovie"
	String s

	If (cmpstr(ask,"yes")==0) 
		NewMovie/F=10/L/O/P=chemin/Z as spectramoviename
	Endif

	For(j=0;j<phimax-phimin+1;j+=1)
		print "Azimuthal angle =",j+phimin,"deg.",nombin
		phi_detec=j+phimin

		//----------------------load------------------------------------------------------------------------------------------------------------------------------------------

		xdim=dimsize(gisaxs2d,0)
		ydim=dimsize(gisaxs2d,1)

		GBLoadWave/A=source/P=chemin/T={80,4}/W=1 nombin
		Redimension/N=(xdim,ydim) source1
		Duplicate/O/D source1 gisaxs2D0
		MatrixTranspose gisaxs2D0
		Reverse/dim=1/P gisaxs2D0
		Reverse/dim=0/P gisaxs2D0
		gisaxs2D=gisaxs2D0
		Killwaves source1,gisaxs2D0

		If (cmpstr(ask,"yes")==0) 
			SetDrawEnv fsize=16,textrgb=(65535,65535,65535)
			sprintf s,"\\F'Symbol'j\\F'Arial' = %2.0f"+" deg", phi_detec
			DrawText 0.65,0.18,s
			SetDrawLayer UserFront

			DoUpdate

			AddMovieFrame
			SetDrawLayer/K UserFront
		Else
			DoUpdate
		Endif

		//----------------------cut------------------------------------------------------------------------------------------------------------------------------------------
		i=1
		pixelYdeb=0
		pixelYfin=numpnts(twothetaf)-2
		pixelZdeb=-1
		Do
			pixelZdeb=pixelZdeb+1
		While (alphaf[pixelZdeb]<cut_pos-cut_width/2)
		pixelZfin=pixelZdeb
		Do
			pixelZfin=pixelZfin+1
		While (alphaf[pixelZfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX  wavevector0 
		Duplicate/O/D W_ImageLineProfile scatintensity0
		wavevector0=x

		Do
			pixelZdeb=pixelZdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity0=scatintensity0+profiletemp
			i=i+1
		While (pixelZdeb<pixelZfin-1)

		scatintensity0=scatintensity0/i

		Killwaves/Z profiletemp,xPixel,yPixel,W_LineProfileX,W_LineProfileY,W_ImageLineProfile,tempx,tempy,tempimage,tempradius,tempangle,tempsector,radial0

		scatintensity2D[][j]=scatintensity0[p]
		
		nombin=nombintemp+num2str(j+firstimage+1)+".bin"
		
	Endfor

	If (cmpstr(ask,"yes")==0) 
		CloseMovie
		Print "GISAXS movie has been created"
	Endif

	//----------------------display image------------------------------------------------------------------------------------------------------------------------------------------

	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity2D vs {twothetaf,phif}
	ModifyImage scatintensity2D ctab= {*,*,Geo,0}
	ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
	Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"
	DoWindow/C cut2d
	
	Killwaves source0
	phi_detec=phimin

	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(2)
	DoWindow/C Fit2d_parameters
		
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_RSMsixsasc(ctrlName) : ButtonControl
	String ctrlName
	NVAR long_onde,cut_pos,cut_width,alphai_detec,phi_detec
	Variable/G rsmvar=1
	Wave/D twothetaf,alphaf,gisaxs2d
	String chemin, nombin
	String ask="no"
	Variable xdim,ydim
	Variable pixelYdeb,pixelYfin,pixelZdeb,pixelZfin
	Variable i,j,firstimage,phimin,phimax
	phimin=0
	phimax=90
	
	Prompt phimin,"Azimuthal angle min. (deg.):"
	Prompt phimax,"Azimuthal angle max. (deg.):"
	Prompt ask, "Create video:", popup "yes;no;"
	DoPrompt "Enter parameters",phimin,phimax,ask
	
	DoWindow/K cut2d
	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	Killwaves/Z Fit_scatintensity2D,Res_scatintensity2D,simgisaxs2D

	Make/O/N=(numpnts(twothetaf)-1,phimax-phimin+1)/D scatintensity2D
	Make/O/N=(phimax-phimin+2)/D phif
	phif=x+phimin-0.5

	Duplicate/O/D scatintensity2D simtwothetaf,simalphaf,simphif,wavevector_xtemp, wavevector_ytemp, wavevector_x2D, wavevector_y2D, wavevector_z2D
	simtwothetaf[][]=twothetaf[p]
	simalphaf=cut_pos
	simphif=y+phimin
	
	wavevector_xtemp[][]=2*pi/long_onde*(cos(simtwothetaf*pi/180)*cos(simalphaf*pi/180)-cos(alphai_detec*pi/180))
	wavevector_ytemp[][]=2*pi/long_onde*(sin(simtwothetaf*pi/180)*cos(simalphaf*pi/180))
	wavevector_x2D[][]=wavevector_xtemp*cos(simphif*pi/180)+wavevector_ytemp*sin(simphif*pi/180)
	wavevector_y2D[][]=-wavevector_xtemp*sin(simphif*pi/180)+wavevector_ytemp*cos(simphif*pi/180)
	wavevector_z2D[][]=2*pi/long_onde*(sin(simalphaf*pi/180)+sin(alphai_detec*pi/180))
	
	Duplicate/O/D twothetaf simtwothetaf

	KillWaves wavevector_xtemp, wavevector_ytemp	
	
	LoadWave/A=source/B="F=-2;"/J/Q
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]

	String nombintemp=nombin[0,strlen(nombin)-5]
	i=0
	Do
		i+=1
	While (numtype(str2num(nombintemp[strlen(nombintemp)-i,strlen(nombintemp)]))==0)

	firstimage=str2num(nombintemp[strlen(nombintemp)-i+1,strlen(nombintemp)])
	nombintemp=nombintemp[0,strlen(nombintemp)-strlen(num2str(firstimage))-1]
	print firstimage,nombintemp

	String spectramoviename="GISAXSmovie"
	String s

	If (cmpstr(ask,"yes")==0) 
		NewMovie/F=10/L/O/P=chemin/Z as spectramoviename
	Endif

	For(j=0;j<phimax-phimin+1;j+=1)
		print "Azimuthal angle =",j+phimin,"deg.",nombin
		phi_detec=j+phimin

		//----------------------load------------------------------------------------------------------------------------------------------------------------------------------

		xdim=dimsize(gisaxs2d,0)
		ydim=dimsize(gisaxs2d,1)

		LoadWave/A=source/D/Q/G/P=chemin nombin
		Redimension/N=(xdim,ydim) source1
		Duplicate/O/D source1 gisaxs2D0
		MatrixTranspose gisaxs2D0
		Reverse/dim=1/P gisaxs2D0
		Reverse/dim=0/P gisaxs2D0		//
		gisaxs2D=gisaxs2D0
		Killwaves source1,gisaxs2D0

		If (cmpstr(ask,"yes")==0) 
			SetDrawEnv fsize=16,textrgb=(65535,65535,65535)
			sprintf s,"\\F'Symbol'j\\F'Arial' = %2.0f"+" deg", phi_detec
			DrawText 0.65,0.18,s
			SetDrawLayer UserFront

			DoUpdate

			AddMovieFrame
			SetDrawLayer/K UserFront
		Else
			DoUpdate
		Endif

		//----------------------cut------------------------------------------------------------------------------------------------------------------------------------------
		i=1
		pixelYdeb=0
		pixelYfin=numpnts(twothetaf)-2
		pixelZdeb=-1
		Do
			pixelZdeb=pixelZdeb+1
		While (alphaf[pixelZdeb]<cut_pos-cut_width/2)
		pixelZfin=pixelZdeb
		Do
			pixelZfin=pixelZfin+1
		While (alphaf[pixelZfin]<cut_pos+cut_width/2)

		Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
		ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
		Duplicate/O/D W_LineProfileX  wavevector0 
		Duplicate/O/D W_ImageLineProfile scatintensity0
		wavevector0=x

		Do
			pixelZdeb=pixelZdeb+1
			Make/O/N=2 xPixel={pixelYdeb,pixelYfin},yPixel={pixelZdeb,pixelZdeb}
			ImageLineProfile xwave=xPixel, ywave=yPixel, srcwave=gisaxs2D
			Duplicate/O/D W_ImageLineProfile profiletemp
			scatintensity0=scatintensity0+profiletemp
			i=i+1
		While (pixelZdeb<pixelZfin-1)

		scatintensity0=scatintensity0/i

		Killwaves/Z profiletemp,xPixel,yPixel,W_LineProfileX,W_LineProfileY,W_ImageLineProfile,tempx,tempy,tempimage,tempradius,tempangle,tempsector,radial0

		scatintensity2D[][j]=scatintensity0[p]
		
		nombin=nombintemp+num2str(j+firstimage+1)+".txt"
	Endfor

	If (cmpstr(ask,"yes")==0) 
		CloseMovie
		Print "GISAXS movie has been created"
	Endif

	//----------------------display image------------------------------------------------------------------------------------------------------------------------------------------

	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity2D vs {twothetaf,phif}
	ModifyImage scatintensity2D ctab= {*,*,Geo,0}
	ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero(bottom)=1
	Label left "\\F'Symbol'j\\F'Arial' (deg)"
	Label bottom "2\\F'Symbol'q\\F'Arial'\\Bf\\M (deg)"
	DoWindow/C cut2d
	
	Killwaves source0
	phi_detec=phimin

	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(2)
	DoWindow/C Fit2d_parameters
		
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_Fit1D(ctrlName) : ButtonControl
	String ctrlName

	RemoveFromGraph/Z fit_peakposition
	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	askfittingparameters(1)
	DoWindow/C Fit1d_parameters
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_guinierplot(ctrlName) : ButtonControl
	String ctrlName
	Wave/D wavevector,scatintensity
	DoWindow/K Guinier_plot
	Duplicate/O/D wavevector wavevector2
	Duplicate/O/D scatintensity logscatintensity
	wavevector2=wavevector^2
	logscatintensity=Ln(scatintensity)
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

Function ButtonProc_peakposition(ctrlName) : ButtonControl
	String ctrlName
	Wave/D scatintensity,wavevector,W_coef,twothetaf,alphaf
	NVAR cut_angle
	CurveFit/Q gauss  scatintensity[pcsr(A),pcsr(B)] /D /X=wavevector /D 
	ModifyGraph rgb(fit_scatintensity)=(16384,16384,65280)
	Print "Fit from x =",wavevector[V_startRow]," to x =",wavevector[V_endRow],", peak at xmax =",W_coef(2),"(2pi/xmax =",2*pi/W_coef(2),")"
	RemoveFromGraph/Z fit_peakposition
	KillWaves/Z fit_peakposition
	Rename fit_scatintensity fit_peakposition
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_guinierslope(ctrlName) : ButtonControl
	String ctrlName
	Wave/D logscatintensity,wavevector2,W_coef
	If (numtype(str2num(StringByKey("point", CsrInfo(A))))==2)		// si le curseur A n'existe pas sur le graph
		Abort "Cursor A is not present on the graph !"
	Endif
	If (numtype(str2num(StringByKey("point", CsrInfo(B))))==2)		// si le curseur B n'existe pas sur le graph
		Abort "Cursor B is not present on the graph !"
	Endif
	CurveFit/Q line  logscatintensity[pcsr(A),pcsr(B)] /X=wavevector2 /D 
	ModifyGraph rgb(fit_logscatintensity)=(16384,16384,65280)
	Print "Guinier Plot: slope =",W_coef(2),"nm?->	Guinier diameter: Dg =", 2*sqrt(-3*W_coef(2)),"nm	->	Diameter: D =", 2*sqrt(-3*W_coef(2))*sqrt(5/3),"nm"
	If (sqrt(wavevector2[V_startRow])<sqrt(wavevector2[V_endRow]))
		Print "	----- Correlation of",V_Pr,"from q =",sqrt(wavevector2[V_startRow]),"1/nm [",V_startRow,"] to",sqrt(wavevector2[V_endRow]),"1/nm [",V_endRow,"] -----"
	Else
		Print "	----- Correlation of",V_Pr,"from q =",-sqrt(wavevector2[V_startRow]),"1/nm [",V_startRow,"] to",-sqrt(wavevector2[V_endRow]),"1/nm [",V_endRow,"] -----"
	Endif
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_differentiate(ctrlName) : ButtonControl
	String ctrlName
	Wave/D logscatintensity,wavevector2	
	Differentiate logscatintensity/X=wavevector2
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_linscale1d(ctrlName) : ButtonControl
	String ctrlName
	Button intens21 disable=1
	Button intens22 disable=0
	ModifyGraph log(left)=0
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_logscale1d(ctrlName) : ButtonControl
	String ctrlName
	Button intens21 disable=0
	Button intens22 disable=1
	ModifyGraph log(left)=1
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProc_renamewavecut(ctrlName) : ButtonControl
	String ctrlName
	String new_wa_name="wavevector"
	String new_sc_name="scatintensity"
	String new_wi_name="cut"
	
	Prompt new_wa_name, "Enter new wavector name: "
	Prompt new_sc_name, "Enter new scatintensity name: "
	Prompt new_wi_name, "Enter new window name: "
	DoPrompt "Enter new wave names", new_wa_name, new_sc_name,new_wi_name
	
	Rename wavevector,$new_wa_name; Rename scatintensity,$new_sc_name;
	PopupMenu popup0 disable=1
	Button intens0 disable=1
	Button intens1 disable=1
	Button intens5 disable=1
	Button intens6 disable=1
	DoWindow/C $new_wi_name
End

//°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°?
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°?
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°?

Function Load_d22()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String ligne, chemin, nombin
	Variable xdim, ydim, file1, directYtemp

	Open/R/M="Choisir le fichier (extension .hea)"/T=".hea"  file1
	Silent 1

	Do
		FReadLine file1,ligne
	While(CmpStr(ligne[0,3],"xdim")!=0)
	xdim=Str2Num(ligne[17,25])
	FReadLine file1,ligne
	ydim=Str2Num(ligne[17,25])

	Do
		FReadLine file1,ligne
	While(CmpStr(ligne[0,3],"Regr")!=0)
	resolutionX=Str2Num(ligne[12,15])*0.05625
	FReadLine file1, ligne
	resolutionY=Str2Num(ligne[12,15])*0.05625

	Do
		FReadLine file1,ligne
	While(CmpStr(ligne[0,3],"mono")!=0)
	long_onde=1239.97/Str2Num(ligne[7,25])

	FStatus file1
	Close file1

	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)-4]+"bin"			//strlen(str ) <> Returns the number of characters in the string expression str.
	GBLoadWave/B/A=source/P=chemin/T={32,4}/W=1/F=1 nombin	//GBLoadWave [/A[=baseName]/D[=d]/N[=baseName] /O[=o] /P=pathName  /I[=TYPE] /Q[=q] /V[=v]/T={fType, wType}/L=l/F=f/J=j/B/W=w/U=u/S=s/Y={offset, multiplier}] fileNameStr <> The GBLoadWave operation loads data from the named binary file into waves.
	Wave/D source0
	Redimension/N=(xdim,ydim) source0
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0
	Reverse/dim=1/P gisaxs2D

	directYtemp=ydim-1-DirectYinit

	DirectYinit=DirectYtemp

End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_dw31b()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String ligne, chemin, nombin
	Variable xdim, ydim, file1, directYtemp

	Open/R/M="Choisir le fichier (extension .hea)"/T=".hea"  file1
	Silent 1

	Do
		FReadLine file1,ligne
	While(CmpStr(ligne[0,3],"xdim")!=0)
	xdim=Str2Num(ligne[17,25])
	FReadLine file1,ligne
	ydim=Str2Num(ligne[17,25])

	Do
		FReadLine file1,ligne
	While(CmpStr(ligne[0,3],"Regr")!=0)
	resolutionX=Str2Num(ligne[12,15])*0.05625
	FReadLine file1, ligne
	resolutionY=Str2Num(ligne[12,15])*0.05625

	Do
		FReadLine file1,ligne
	While(CmpStr(ligne[0,3],"mono")!=0)
	long_onde=1239.97/Str2Num(ligne[11,25])

	FStatus file1
	Close file1

	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)-4]+"bin"			//strlen(str ) <> Returns the number of characters in the string expression str.
	GBLoadWave/B/A=source/P=chemin/T={32,4}/W=1/F=1 nombin	//GBLoadWave [/A[=baseName]/D[=d]/N[=baseName] /O[=o] /P=pathName  /I[=TYPE] /Q[=q] /V[=v]/T={fType, wType}/L=l/F=f/J=j/B/W=w/U=u/S=s/Y={offset, multiplier}] fileNameStr <> The GBLoadWave operation loads data from the named binary file into waves.
	Wave/D source0
	Redimension/N=(xdim,ydim) source0
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0
	Reverse/dim=1/P gisaxs2D

	directYtemp=ydim-1-DirectYinit

	DirectYinit=DirectYtemp

End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_d2am()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/B="F=-2;"/J/Q
	Wave/T source0
	dimtemp=source0[5]
	xdim=str2num(dimtemp[18,21])
	resolutionX=0.05*1340/str2num(dimtemp[18,21])
	dimtemp=source0[6]
	ydim=str2num(dimtemp[18,21])
	resolutionY=0.05*1300/str2num(dimtemp[18,21])
	bytetemp=source0[2]
	bytetemp=bytetemp[18,20]
	If (cmpstr(bytetemp,"Low")==0)
		byteorder=1
	Else
		byteorder=0
	Endif
	
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={32,4}/S=1024/W=1/F=1/B=(byteorder) nombin
	Wave/D source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1

	If (directXinit < 0.1*xdim)
		MatrixTranspose gisaxs2D
		directYtemp=DirectXinit
		directXtemp=DirectYinit
		ydimtemp=xdim
		xdimtemp=ydim
		resolutionYtemp=resolutionX
		resolutionXtemp=resolutionY
	ElseIf (directXinit > 0.9*xdim)
		MatrixTranspose gisaxs2D
		Reverse/dim=1/P gisaxs2D
		directYtemp=xdim-1-DirectXinit
		directXtemp=DirectYinit
		ydimtemp=xdim
		xdimtemp=ydim
		resolutionYtemp=resolutionX
		resolutionXtemp=resolutionY
	Else
		Reverse/dim=1/P gisaxs2D
		directYtemp=ydim-1-DirectYinit
		directXtemp=DirectXinit
		ydimtemp=ydim
		xdimtemp=xdim
		resolutionYtemp=resolutionY
		resolutionXtemp=resolutionX
	Endif

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_d2am_xpad()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/B="F=-2;"/J/Q
	Wave/T source0
	dimtemp=source0[4]
	xdim=str2num(dimtemp[8,11])
	resolutionX=0.13
	dimtemp=source0[5]
	ydim=str2num(dimtemp[8,11])
	resolutionY=0.13
	bytetemp=source0[2]
	bytetemp=bytetemp[13,15]
	If (cmpstr(bytetemp,"Low")==0)
		byteorder=1
	Else
		byteorder=0
	Endif
	
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={2,4}/S=512/W=1/B=(byteorder) nombin
	Wave/D source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1
	
	If (directXinit < directYinit)
		MatrixTranspose gisaxs2D
		directYtemp=DirectXinit
		directXtemp=DirectYinit
		DirectXinit=directXtemp
		DirectYinit=DirectYtemp
	Endif
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_bm32()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/B="F=-2;"/J/Q
	xdim=1242
	ydim=1152
	resolutionX=0.05625
	resolutionY=0.05625
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={32,4}/S=4096/W=1/F=1/B=1 nombin
	Wave/D source1
	DeletePoints 0,1,source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1

	MatrixTranspose gisaxs2D
	Reverse/dim=1/P gisaxs2D
	directYtemp=xdim-1-DirectXinit
	directXtemp=DirectYinit
	ydimtemp=xdim
	xdimtemp=ydim
	resolutionYtemp=resolutionX
	resolutionXtemp=resolutionY

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_bm20()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/B="F=-2;"/J/Q/L={0, 0, 0, 2, 0 }
	xdim=2048
	ydim=2048
	resolutionX=0.064447
	resolutionY=0.064447
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={16,4}/W=1 nombin
	Wave/D source0
	Redimension/N=(xdim,ydim) source0
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0

	directXtemp=DirectXinit
	directYtemp=DirectYinit
	ydimtemp=xdim
	xdimtemp=ydim
	resolutionYtemp=resolutionX
	resolutionXtemp=resolutionY

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_id10b()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/B="F=-2;"/J/Q
	xdim=1296
	ydim=256
	resolutionX=0.055
	resolutionY=0.055
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]

	GBLoadWave/A=source/P=chemin/T={32,4}/S=3072/W=1/B nombin
	Wave/D source1
	DeletePoints 0,1,source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1

	MatrixTranspose gisaxs2D
	Reverse/P gisaxs2D

	directYtemp=xdim-1-DirectXinit
	directXtemp=ydim-1-DirectYinit
	ydimtemp=xdim
	xdimtemp=ydim
	resolutionYtemp=resolutionX
	resolutionXtemp=resolutionY

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_id01()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/B="F=-2;"/J/Q
	xdim=1242
	ydim=1152
	resolutionX=0.05503
	resolutionY=0.05554
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={2,4}/S=8192/W=1/B nombin
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1

	Reverse/P gisaxs2D
	directYtemp=ydim-1-DirectYinit
	directXtemp=xdim-1-DirectXinit
	ydimtemp=ydim
	xdimtemp=xdim
	resolutionYtemp=resolutionY
	resolutionXtemp=resolutionX
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_swing_asc()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/J/D/Q/M
	Print "File",S_filename,"loaded"
	xdim=Dimsize(source0,0)
	ydim=Dimsize(source0,1)
	Variable bintemp=4096/xdim
	resolutionX=0.04174*bintemp
	resolutionY=0.04174*bintemp
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0
	
	MatrixTranspose gisaxs2D
	Reverse/P gisaxs2D
	Reverse/DIM=0/P gisaxs2D
	
	DirectYinit=ydim-1-DirectYinit
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_swing_edf()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/B="F=-2;"/J/Q
	Wave/T source0
	dimtemp=source0[4]
	xdim=str2num(dimtemp[17,20])
	resolutionX=0.05*1340/str2num(dimtemp[17,20])
	dimtemp=source0[5]
	ydim=str2num(dimtemp[17,20])
	resolutionY=0.05*1300/str2num(dimtemp[17,20])
	bytetemp=source0[2]
	bytetemp=bytetemp[17,19]
	If (cmpstr(bytetemp,"Low")==0)
		byteorder=1
	Else
		byteorder=0
	Endif
	
	dimtemp=source0[25]
	long_onde=1239.97/str2num(dimtemp[50,55])
	dimtemp=source0[24]
	distance=str2num(dimtemp[50,55])
	
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={80,4}/S=4404/W=1/B=(byteorder) nombin
	Wave/D source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1
	
	Reverse/dim=1/P gisaxs2D
	directYtemp=ydim-1-DirectYinit
	directXtemp=DirectXinit
	ydimtemp=ydim
	xdimtemp=xdim
	resolutionYtemp=resolutionY
	resolutionXtemp=resolutionX

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_swing_bin()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/B="F=-2;"/J/Q
	Killwaves/Z source1
	xdim=1024
	ydim=1024
	resolutionX=0.04174*4
	resolutionY=0.04174*4
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={80,4}/W=1 nombin
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1

	Reverse/P gisaxs2D
	Reverse/P/DIM=0 gisaxs2D
	directYtemp=ydim-1-DirectYinit
	directXtemp=DirectXinit
	ydimtemp=ydim
	xdimtemp=xdim
	resolutionYtemp=resolutionY
	resolutionXtemp=resolutionX
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_sixs_bin()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/B="F=-2;"/J/Q
	Killwaves/Z source1
	xdim=2046
	ydim=2046
	resolutionX=0.08
	resolutionY=0.08
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={80,4}/W=1 nombin
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1

	MatrixTranspose gisaxs2D
	Reverse/dim=1/P gisaxs2D
	Reverse/dim=0/P gisaxs2D
	directYtemp=xdim-1-DirectXinit
	directXtemp=DirectYinit
	ydimtemp=xdim
	xdimtemp=ydim
	resolutionYtemp=resolutionX
	resolutionXtemp=resolutionY

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_sixs_asc()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String chemin, nombin
	Variable  xdim, ydim, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/D/Q/G
	Print "File",S_filename,"loaded"
	xdim=2048
	ydim=2048
	resolutionX=0.08
	resolutionY=0.08
	Redimension/N=(xdim,ydim) source0
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0
	
	MatrixTranspose gisaxs2D
	Reverse/dim=1/P gisaxs2D
	Reverse/dim=0/P gisaxs2D		//
	directYtemp=xdim-DirectXinit
	directXtemp=ydim-DirectYinit		// DirectYinit-1
	ydimtemp=xdim
	xdimtemp=ydim
	resolutionYtemp=resolutionX
	resolutionXtemp=resolutionY

	resolutionX=resolutionXtemp
	resolutionY=resolutionYtemp
	DirectXinit=directXtemp
	DirectYinit=DirectYtemp
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_sixs_xpad()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
//	String chemin, nombin
//	Variable  directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp
	
	LoadWave/A=source/D/Q/G/M
	Print "File",S_filename,"loaded"
//	xdim=dimsize(source0,0)
//	ydim=dimsize(source0,1)
	resolutionX=0.13
	resolutionY=0.13
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0
	
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_ip()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	Variable xdim, ydim
	String chemin, nombin

	LoadWave/A=source/B="F=-2;"/J/Q
	xdim=540
	ydim=307
	resolutionX=0.176
	resolutionY=0.176
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={80,4}/B/S=614/W=1 nombin
	Wave/D source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_imagefile()
	NVAR resolutionX, resolutionY
	Variable resolutionXtemp=resolutionX
	Variable resolutionYtemp=resolutionY
	
	Prompt resolutionXtemp, "Horizontal pixel size (mm):"
	Prompt resolutionYtemp, "Vertical pixel size (mm):"
	DoPrompt "Enter parameters", resolutionXtemp, resolutionYtemp
	
	ImageLoad/T=tiff/O/N=gisaxs2D
	Reverse/DIM=1/P gisaxs2d
	resolutionX=resolutionXtemp
	resolutionY=resolutionXtemp
End


//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_textfile()
	NVAR resolutionX, resolutionY
	Variable resolutionXtemp=resolutionX
	Variable resolutionYtemp=resolutionY
	
	Prompt resolutionXtemp, "Horizontal pixel size (mm):"
	Prompt resolutionYtemp, "Vertical pixel size (mm):"
	DoPrompt "Enter parameters", resolutionXtemp, resolutionYtemp
	
	LoadWave/A=source/D/Q/G/M
	Print "File",S_filename,"loaded"
	resolutionX=resolutionXtemp
	resolutionY=resolutionXtemp
	Duplicate/O/D source0 gisaxs2D
	Killwaves source0
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function correctmonitoring()
	Wave/D gisaxs2D
	Wave/T textWave1
	Variable Izero=1
	String Fileref=""
	NVAR sinalphai_sample,alphai_detec
	
	Prompt Izero,"Enter monitor intensity"
	Prompt Fileref,"Enter reference file"
	DoPrompt "Monitoring",Izero,Fileref
	If (Izero!=1)
		If (cmpstr(textWave1[3],"Supported islands")==0)
			gisaxs2D=gisaxs2D/Izero*sin(alphai_detec*pi/180)
			Print "gisaxs2D = gisaxs2D /",Izero,"/",1/sin(alphai_detec*pi/180)
		Else
			gisaxs2D=gisaxs2D/Izero*sinalphai_sample
			Print "gisaxs2D = gisaxs2D /",Izero,"/",1/sinalphai_sample
		Endif
	Endif

	If (cmpstr(Fileref,"")!=0)
		Fileref="gisaxs2D-="+Fileref
		Execute Fileref
		Print Fileref
	Endif
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_swingbin()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/B="F=-2;"/J/Q
	Variable bintemp=4
	xdim=4096/bintemp
	ydim=4096/bintemp
	resolutionX=0.041*bintemp
	resolutionY=0.041*bintemp
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={80,4}/W=1 nombin
	Wave/D source1
	Variable numtemp=numpnts(source1)-xdim*ydim
print numtemp	
	DeletePoints 0,numtemp,source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1
	
	Reverse/dim=1/P gisaxs2D
	
	DirectYinit=ydim-1-DirectYinit
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_swing1()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/B="F=-2;"/J/Q
	Variable bintemp=4
	xdim=4096/bintemp
	ydim=4096/bintemp
	resolutionX=0.041*bintemp
	resolutionY=0.041*bintemp
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={2,4}/W=1/F=1/B=1 nombin
	Wave/D source1
	Variable numtemp=numpnts(source1)-xdim*ydim
	DeletePoints 0,numtemp,source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1
	
	Reverse/dim=1/P gisaxs2D
	
	DirectYinit=ydim-1-DirectYinit
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Load_swing2()
	NVAR resolutionX, resolutionY, directXinit, directYinit, alphai_detec, distance, long_onde
	String dimtemp, bytetemp, chemin, nombin
	Variable xdim, ydim, byteorder, directXtemp, xdimtemp, resolutionXtemp, directYtemp, ydimtemp, resolutionYtemp

	LoadWave/A=source/B="F=-2;"/J/Q
	Variable bintemp=4
	xdim=4096/bintemp
	ydim=4096/bintemp
	resolutionX=0.041*bintemp
	resolutionY=0.041*bintemp
	NewPath/O/Q chemin, s_path
	nombin=s_filename[0,StrLen(s_filename)]
	GBLoadWave/A=source/P=chemin/T={2,4}/W=1/F=1/B=1/J=2 nombin
	Wave/D source1
	Variable numtemp=numpnts(source1)-xdim*ydim
	DeletePoints 0,numtemp,source1
	Redimension/N=(xdim,ydim) source1
	Duplicate/O/D source1 gisaxs2D
	Killwaves source0,source1
	
	Reverse/dim=1/P gisaxs2D
	
	DirectYinit=ydim-1-DirectYinit
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

Function qxqymap(npnts)
	Variable npnts
	DoWindow/K qyqxmap
	NVAR Vmincol,Vmaxcol
	Wave/D scatintensity2D,wavevector_x2D, wavevector_y2D
//	Variable npnts=round(DimSize(scatintensity2D,0)/2)
	
	Wavestats/Q wavevector_x2D
	Variable qxmin=V_min
	Variable qxmax=V_max
	Wavestats/Q wavevector_y2D
	Variable qymin=V_min
	Variable qymax=V_max
	
	Variable i,j
	Variable xpnt,ypnt

	Make/N=(npnts)/D/O qxwave
	Make/N=(npnts)/D/O qywave
	SetScale/I x qxmin,qxmax,"", qxwave
	SetScale/I x qymin,qymax,"", qywave
	Make/O/N=(npnts,npnts)/D scatintensity_qxqy
	SetScale/I x qymin,qymax,"", scatintensity_qxqy
	SetScale/I y qxmin,qxmax,"", scatintensity_qxqy

	scatintensity_qxqy=0
	Duplicate/O scatintensity_qxqy nbrepoints

	For(j=0;j<DimSize(scatintensity2D,1);j+=1)
		For(i=0;i<DimSize(scatintensity2D,0);i+=1)
			xpnt=x2pnt(qywave, wavevector_y2D[i][j] )
			ypnt=x2pnt(qxwave, wavevector_x2D[i][j] )
//			scatintensity_qxqy[xpnt][ypnt]=scatintensity2D[i][j]
			nbrepoints[xpnt][ypnt]+=1
			scatintensity_qxqy[xpnt][ypnt]+=scatintensity2D[i][j]
		Endfor
	Endfor
	
	scatintensity_qxqy=scatintensity_qxqy/max(1,nbrepoints)
	
	KillWaves nbrepoints
	
	Display/M/W=(16.6, 5.3, 21, 11);AppendImage scatintensity_qxqy
	ModifyImage scatintensity_qxqy ctab= {Vmincol,Vmaxcol,Geo,0}
	ModifyGraph width=200, height={Aspect,1},fSize=10,btLen=3,zero=1
	Label left "q\Bx\M (nm\S-1\M)"
	Label bottom "q\By\M (nm\S-1\M)"
	DoWindow/C qyqxmap

End

Function corRSMxpad(val)
	Variable val
	Wave/D scatintensity2D
	Variable i
	
	For(i=0;i<DimSize(scatintensity2D,1);i+=1)
		If (scatintensity2D[50][i]>val)
			scatintensity2D[][i]=(scatintensity2D[p][i-1]+scatintensity2D[p][i+1])/2
		Endif
	Endfor
End

//---------------------------------------------------------------------------------------------------------------------------------------------------------------


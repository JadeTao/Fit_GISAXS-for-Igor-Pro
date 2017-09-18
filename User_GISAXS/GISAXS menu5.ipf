#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

// 生成菜单
Menu "FitGISAXS"
	// 此菜单用来从已有外部数据中加载
	Submenu "Load GISAXS..."
		// 从 tiff 图片中加载 GISAXS 数据
		"Image file", LoadNewGISAXS("imagefile")
		// 从文本中加载 GISAXS 数据
		"Text file", LoadNewGISAXS("textfile")
		"-",
		// 以下为不同的光线种类
		Submenu "D2AM-ESRF"
			"D2AM-CCD", LoadNewGISAXS("d2am")
			"D2AM-XPAD", LoadNewGISAXS("d2am_xpad")
		End
		"BM32-ESRF", LoadNewGISAXS("bm32")
		"BM20-ESRF", LoadNewGISAXS("bm20")
		"ID01-ESRF", LoadNewGISAXS("id01")
		"ID10B-ESRF", LoadNewGISAXS("id10b")
		Submenu "SWING-SOLEIL"
			"SWING-BIN", LoadNewGISAXS("swing_bin")
			"SWING-ASCII", LoadNewGISAXS("swing_asc")
			"SWING-EDF", LoadNewGISAXS("swing_edf")
		End
		Submenu "SIXS-SOLEIL"
			"SIXS-BIN", LoadNewGISAXS("sixs_bin")
			"SIXS-ASCII", LoadNewGISAXS("sixs_asc")
			"SIXS-XPAD", LoadNewGISAXS("sixs_xpad")
		End
		"-",
		"D22-LURE", LoadNewGISAXS("d22")
		"DW31B-LURE", LoadNewGISAXS("dw31b")
		"Imaging Plate", LoadNewGISAXS("ip")
	End
	// 此菜单用来从0创建 GISAXS 信息
	Submenu "Create GISAXS..."
		"Qy,Qz map", CreateNewGISAXS2D("QyQz_map")
		"Qy,Qx map", CreateNewGISAXS2D("QxQy_map")
		"Qy,Phi map", CreateNewGISAXS2D("QyPhi_map")
		"Qy cut", CreateNewGISAXS1D("Qy_cut")
		"Qz cut", CreateNewGISAXS1D("Qz_cut")
//		"Qx,Qz map", CreateNewGISAXS2D("QxQz_map") 
	End
	"-",
	// 下三个选项用来显示/隐藏 Layer_parameters GISAXS_parameters Fit_parameters窗口
	"Layer parameters...", askLAYERparameters()
	"GISAXS parameters...", askGISAXSparameters()
	"Fit parameters...", askFITparameters()
	"-",
	// 绘制形状因子
	"Plot form factor...", pfactor()
	// 绘制结构因子
	"Plot structure factor...", sfactor()

	// 以下两个选项有调用限制

	// 绘制尺寸分布
	MAstring+"Plot size distribution...", dsize()
	// 绘制型状分布
	MAstring+"Plot shape distribution...", dshape()
	"-",
	// 绘制反射
	"Plot reflection...", Reflection_coef()
	// 绘制转化
	"Plot transmission...", Transmission_coef()
	绘制穿透深度
	"Plot penetration depth...", Penetration_depth()
	// EFI 是什么？
	Submenu "Plot EFI..."
		"EFI 1D vs depth", Map1d2z_efi()
		"EFI 1D vs angle", Map1d2a_efi()
		"-",
		"EFI 2D", Map2d_efi()
		"-",
		"U-", Calcul_champincidentmoins()
		"U+", Calcul_champincidentplus()
		"V-", Calcul_champincidentmoinsdown()
		"V+", Calcul_champincidentplusdown()
	End
	"-",
	// X 光相关数据超链接
	Submenu "X-ray database..."
		"CXRO home page...",	BrowseURL/Z  "http://henke.lbl.gov/optical_constants/"
		"SCM-AXS database...",BrowseURL/Z  "http://res.tagen.tohoku.ac.jp/~waseda/scm/AXS/index.html"
		"Cromer-Lieberman code...",BrowseURL/Z  "http://usaxs.xor.aps.anl.gov/staff/ilavsky/AtomicFormFactors.html"
		"WebElements...",BrowseURL/Z  "http://www.webelements.com/"
	End
End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot size distribution..." 时调用此函数
Function DSize()
	Wave/D coef
	NVAR Dmin,Dmax
	DoWindow/K Size_distribution

	Make/O/N=1001/D height0,frequencyD,temp
	SetScale/I x Dmin,Dmax,"", height0,frequencyD,temp
	Duplicate/O temp temp3,temp4
	frequencyD=Size_dist(coef,x)
	temp=frequencyD*x
	temp3=frequencyD*x^3
	temp4=frequencyD*x^4
	Display frequencyD
	DoWindow/C Size_distribution
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14
	Label left "Frequency"
	Label bottom "Size (nm)"
	ShowInfo
	Print "D distribution: Area =",area(frequencyD,0,Dmax),", Mean =",sum(temp)/sum(frequencyD),", Weighted =",sum(temp4)/sum(temp3)
	height0=Shape_dist(coef,x)*x
	Wavestats/Q height0
	Duplicate/O/D frequencyD,frequencyH
	frequencyH=frequencyD*area(frequencyD,0,Dmax)/areaXY(height0,frequencyD,0,V_max)
	AppendToGraph frequencyH vs height0
	ModifyGraph rgb(frequencyH)=(0,0,0),lstyle(frequencyH)=2
	Legend/C/N=text0/J/F=0/M/A=RB "\\s(frequencyD) D\r\\s(frequencyH) H"
	temp=frequencyH*height0
	temp3=frequencyH*height0^3
	temp4=frequencyH*height0^4
	Print "H distribution: Area =",areaXY(height0,frequencyH,0,V_max),", Mean =",sum(temp)/sum(frequencyH),", Weighted =",sum(temp4)/sum(temp3)
	Killwaves temp,temp3,temp4
End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot shape distribution..." 时调用此函数
Function DShape()
	Wave/D coef
	NVAR Dmin,Dmax
	Make/O/N=1001/D aspectratio1,height1
	SetScale/I x Dmin,Dmax,"", aspectratio1,height1
	
	// 主内容窗口
	DoWindow/K Shape_distribution
	aspectratio1=Shape_dist(coef,x)
	height1=aspectratio1*x
	Display height1
	AppendToGraph/R aspectratio1
	DoWindow/C Shape_distribution
	ModifyGraph btLen=5, lsize(height1)=2, fSize=14, mirror(bottom)=2, rgb(aspectratio1)=(0,0,0)
	Legend/C/N=text0/J/F=0/M/A=RB "\\s(height1) H\r\\s(aspectratio1) H/D"
	SetAxis/A/E=1 left
	SetAxis/A/E=1 right
	Label right "H/D"
	Label left "H (nm)"
	Label bottom "D (nm)"
	ShowInfo
End

//----------------------------------------------------------------------------------------------------------------------------------
// 点击 "Plot form factor..." 时调用此函数
Function pfactor()
	Wave/D coef

	// NumVarOrDefault 函数，寻找与第一个参数同名的全局参数，有则返回之，无则返回第二个参数
	Variable qymin=NumVarOrDefault("qy_min",-2.5)
	Variable qymax=NumVarOrDefault("qy_max",2.5)
	Variable qzmin=NumVarOrDefault("qz_min",0)
	Variable qzmax=NumVarOrDefault("qz_max",2.5)

	// 弹出输入提示框
	Prompt qymin,"qy min. (1/nm):"
	Prompt qymax,"qy max. (1/nm):"
	Prompt qzmin,"qz min. (1/nm):"
	Prompt qzmax,"qz max. (1/nm):"
	DoPrompt "Enter parameters", qymin,qymax,qzmin,qzmax

	// 重新定义全局变量
	Variable/G qy_min=qymin
	Variable/G qy_max=qymax
	Variable/G qz_min=qzmin
	Variable/G qz_max=qzmax

	// 主内容窗口
	DoWindow/K Formfactor
	Make/N=1001/O/D formfactorqy,formfactorqz
	SetScale/I x qy_min,qy_max,"", formfactorqy
	SetScale/I x qz_min,qz_max,"", formfactorqz
	formfactorqy=magsqr(Form_factor(1e-3,x,1e-3,coef[2],coef[2]*Shape_dist(coef,coef[2])))
	formfactorqz=magsqr(Form_factor(1e-3,1e-3,x,coef[2],coef[2]*Shape_dist(coef,coef[2])))

	// 生成图像的函数	
	Display formfactorqy
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14, zero(bottom)=1
	AppendToGraph formfactorqz
	ModifyGraph rgb(formfactorqz)=(0,0,0),lstyle(formfactorqz)=2
	Legend/C/N=text0/J/F=0/M/A=RT "\\s(formfactorqy) P(q\\By\\M)\r\\s(formfactorqz) P(q\\Bz\\M)"	
	DoWindow/C Formfactor
	// 纵坐标
	Label left "P(q)"
	// 横坐标
	Label bottom "q (nm\\S-1\\M)"
	ShowInfo
End

//----------------------------------------------------------------------------------------------------------------------------------
// 点击 "Plot structure factor..." 时调用此函数
Function sfactor()
	Wave/D coef
	Variable qymin=NumVarOrDefault("qy_min",-2.5)
	Variable qymax=NumVarOrDefault("qy_max",2.5)
	Variable qzmin=NumVarOrDefault("qz_min",0)
	Variable qzmax=NumVarOrDefault("qz_max",2.5)

	// 弹出输入提示框
	Prompt qymin,"qy min. (1/nm):"
	Prompt qymax,"qy max. (1/nm):"
	Prompt qzmin,"qz min. (1/nm):"
	Prompt qzmax,"qz max. (1/nm):"
	DoPrompt "Enter parameters", qymin,qymax,qzmin,qzmax

	// 重新定义全局变量
	Variable/G qy_min=qymin
	Variable/G qy_max=qymax
	Variable/G qz_min=qzmin
	Variable/G qz_max=qzmax

	// 主内容窗口
	DoWindow/K Structurefactor
	Make/N=1001/O/D structurefactorqy,structurefactorqz
	SetScale/I x qy_min,qy_max,"", structurefactorqy
	SetScale/I x qz_min,qz_max,"", structurefactorqz
	structurefactorqy=Structure_Factor(1e-3,x,1e-3,coef[2]*coef[4],coef[2]*Shape_dist(coef,coef[2])*coef[4],coef[5])
	structurefactorqz=Structure_Factor(1e-3,1e-3,x,coef[2]*coef[4],coef[2]*Shape_dist(coef,coef[2])*coef[4],coef[5])

	Display structurefactorqy
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14, zero(bottom)=1
	AppendToGraph structurefactorqz
	ModifyGraph rgb(structurefactorqz)=(0,0,0),lstyle(structurefactorqz)=2
	Legend/C/N=text0/J/F=0/M/A=RB "\\s(structurefactorqy) S(q\\By\\M)\r\\s(structurefactorqz) S(q\\Bz\\M)"	
	DoWindow/C Structurefactor
	Label left "S(q)"
	Label bottom "q (nm\\S-1\\M)"
	ShowInfo

	// 附加一个按钮，寻找峰值
	Button intens1 title="Peak position", proc=ButtonProc_peakposition1, pos={80,195}, size={75,20}, fSize=11
End

//		-----------------			-----------------			-----------------			-----------------

// 用于寻找峰值的函数
Function ButtonProc_peakposition1(ctrlName) : ButtonControl
	String ctrlName
	Wave/D structurefactorqy,structurefactorqz,W_coef

	If (numtype(str2num(StringByKey("point", CsrInfo(A))))==2)		// si le curseur A n'existe pas sur le graph
		Abort "Cursor A is not present on the graph !"
	Endif
	If (numtype(str2num(StringByKey("point", CsrInfo(B))))==2)		// si le curseur B n'existe pas sur le graph
		Abort "Cursor B is not present on the graph !"
	Endif

	String cmd="CurveFit/Q/NTHR=1 gauss  "+StringByKey("tname", CsrInfo(A))+"[pcsr(B),pcsr(A)] /D "
	Execute cmd
	cmd="ModifyGraph rgb(fit_"+StringByKey("tname", CsrInfo(A))+")=(0,0,65280)"
	Execute cmd
	Legend/C/N=text0/J/F=0/M/A=RB "\\s(structurefactorqy) S(q\\By\\M)\r\\s(structurefactorqz) S(q\\Bz\\M)"	
	Print "	Peak position: qmax =", W_coef(2),"1/nm, Interparticle distance: L =",2*pi/abs(W_coef(2)),"nm"
End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot reflection..." 时调用此函数
// "coef" is abbreviation of "coefficient"，即系数
Function Reflection_coef()
	NVAR long_onde
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde

	// 弹出输入提示框
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", alphamin,alphamax,nrj

	// 重新定义全局变量
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax
	long_onde=1239.97/nrj

	// 主内容窗口
	DoWindow/K coef_reflection
	Make/N=1001/O/D reflected_intensity
	SetScale/I x alpha_min,alpha_max,"", reflected_intensity
	// 反射强度
	reflected_intensity=magsqr(calcul_reflecto(x))
	
	// 计算反射强度的函数
	Display reflected_intensity
	ModifyGraph mirror=2, btLen=5, lsize=2, log(left)=1, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "I\\Br\\M / I\\B0\\M"
	ShowInfo
	DoWindow/C coef_reflection
End

//		-----------------			-----------------			-----------------			-----------------
// 计算反射强度，参数：graz angle
Function/C calcul_reflecto(grazangle)
	Variable grazangle
	NVAR long_onde
	Wave/D delta,betta,thickness,roughness
	Variable/C m11i,m12i,m21i,m22i,m11f,m12f,m21f,m22f,kzi,kzf,r11,r12,t11,t22
	m11i=1
	m12i=0
	m21i=0
	m22i=1
	kzi=-2*pi/long_onde*sqrt((1)^2-(cos(grazangle*pi/180))^2)

	Variable k
	For(k=0;k<numpnts(delta)-1;k+=1)
		kzf=-2*pi/long_onde*sqrt((1-delta[k]-sqrt(-1)*betta[k])^2-(cos(grazangle*pi/180))^2)
		r11=(kzi+kzf)/(2*kzi)
		r12=(kzi-kzf)/(2*kzi)*exp(-2*kzi*kzf*roughness[k]^2)
		t11=exp(sqrt(-1)*kzf*thickness[k])
		t22=exp(-sqrt(-1)*kzf*thickness[k])
		
		m11f=t11*(m11i*r11+m12i*r12)
		m12f=t22*(m11i*r12+m12i*r11)
		m21f=t11*(m21i*r11+m22i*r12)
		m22f=t22*(m21i*r12+m22i*r11)
		
		kzi=kzf
		m11i=m11f
		m12i=m12f
		m21i=m21f
		m22i=m22f
	Endfor

	kzf=-2*pi/long_onde*sqrt((1-delta[numpnts(delta)-1]-sqrt(-1)*betta[numpnts(delta)-1])^2-(cos(grazangle*pi/180))^2)
	r11=(kzi+kzf)/(2*kzi)
	r12=(kzi-kzf)/(2*kzi)*exp(-2*kzi*kzf*roughness[numpnts(delta)-1]^2)
	
	m11f=m11i*r11+m12i*r12
	m12f=m11i*r12+m12i*r11
	m21f=m21i*r11+m22i*r12
	m22f=m21i*r12+m22i*r11

	Return (m12f/m22f)
End

//----------------------------------------------------------------------------------------------------------------------------------
// 点击 "Plot transmission..." 时调用此函数
Function Transmission_coef()
	NVAR long_onde
	Wave/D delta,betta
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde

	// 弹出输入提示框
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", alphamin,alphamax,nrj
	 
	// 重新定义全局变量
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax
	long_onde=1239.97/nrj

	// 主内容窗口
	DoWindow/K coef_transmission
	Make/D/N=1001/O transmitted_intensity
	SetScale/I x alpha_min,alpha_max,"", transmitted_intensity
	transmitted_intensity=Calcul_transmission(x,delta[0],betta[0])

	// 计算转化强度的函数
	Display transmitted_intensity
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "I\\Bt\\M / I\\B0\\M"
	ShowInfo
	DoWindow/C coef_transmission
	Print "delta =",delta[0],", beta =",betta[0]
	Print "critical angle =",sqrt(2*delta[0])*180/pi,"deg., absorption coef =",4*pi*betta[0]/(long_onde*1e-7),"cm-1"
End

//		-----------------			-----------------			-----------------			-----------------

// 计算转化值，参数： graz angle,变化值,β值
Function Calcul_transmission(grazangle,deltavalue,betavalue)
	Variable grazangle,deltavalue,betavalue
	Variable atemp,btemp
	
	atemp=sqrt(0.5*(sqrt(((grazangle*pi/180)^2-2*deltavalue)^2+4*betavalue^2)+(grazangle*pi/180)^2-2*deltavalue))
	btemp=sqrt(0.5*(sqrt(((grazangle*pi/180)^2-2*deltavalue)^2+4*betavalue^2)-(grazangle*pi/180)^2+2*deltavalue))

	Return 4*(grazangle*pi/180)^2/((grazangle*pi/180+atemp)^2+btemp^2)
End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot penetration depth..." 时调用此函数
Function Penetration_depth()
	NVAR long_onde
	Wave/D delta,betta,thickness
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde

	// 弹出输入提示框
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", alphamin,alphamax,nrj

	// 重新定义全局变量
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax
	long_onde=1239.97/nrj

	// 主内容窗口
	DoWindow/K penetration
	Make/D/N=1001/O depth_intensity
	SetScale/I x alpha_min,alpha_max,"", depth_intensity

	depth_intensity=calcul_profpen(x,delta[0],betta[0])

	// 计算深度强度
	Display depth_intensity
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "Depth (nm)"
	ShowInfo
	DoWindow/C penetration
	Print "delta =",delta[0],", beta =",betta[0]
	Print "critical angle =",sqrt(2*delta[0])*180/pi,"deg., absorption coef =",4*pi*betta[0]/(long_onde*1e-7),"cm-1"
End

//		-----------------			-----------------			-----------------			-----------------
// 计算 profpen(条款？)
Function Calcul_profpen(grazangle,deltavalue,betavalue)
	Variable grazangle,deltavalue,betavalue
	NVAR long_onde

	Return long_onde*sqrt(2)/4/pi/sqrt(sqrt(((grazangle*pi/180)^2-2*(deltavalue))^2+4*(betavalue)^2)-(grazangle*pi/180)^2+2*(deltavalue))
End

//Function calcul_profpen(grazangle)
//	Variable grazangle
//	Wave/D delta,betta,thickness
//	NVAR long_onde

//	Variable itemp,ztemp,ttemp
//	Variable k
//	itemp=0
//	ttemp=0
//	For (k=0;k<numpnts(delta)-1;k+=1)
//		ztemp=long_onde*sqrt(2)/4/pi/sqrt(sqrt(((grazangle*pi/180)^2-2*delta[k])^2+4*betta[k]^2)-(grazangle*pi/180)^2+2*delta[k])
//		itemp+=thickness[k]/ztemp
//		If (itemp>1)
//			itemp-=thickness[k]/ztemp
//			Break
//		Endif
//		ttemp+=thickness[k]
//	Endfor
//	ztemp=long_onde*sqrt(2)/4/pi/sqrt(sqrt(((grazangle*pi/180)^2-2*delta[k])^2+4*betta[k]^2)-(grazangle*pi/180)^2+2*delta[k])
//	Return ttemp+ztemp*(1-itemp)
//End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot EFI..." "U-" 时调用此函数
Function Calcul_champincidentmoins()
	NVAR long_onde,slayer
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde
	Variable interface=slayer
	Variable slayertemp=slayer

	// 弹出输入提示框
	Prompt interface, "Interface # :"
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", interface,alphamin,alphamax,nrj

	If (interface > numpnts(delta)-1)
		Abort "Interface doest not exist !"
	Endif

	slayer=interface
	long_onde=1239.97/nrj
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax

	// 主内容窗口
	DoWindow/K U_moins
	Make/N=1001/O/D Umoins
	SetScale/I x alpha_min,alpha_max,"", Umoins

	Umoins=magsqr(champincidentmoins(x))
	
	Display Umoins
	ModifyGraph mirror=2, btLen=5, lsize=2, log(left)=1, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "|U\\B-\\M|\\S2"
	String cmd
	cmd="TextBox/C/N=text0/M/A=RB \"Interface #"+num2str(interface)+"\""
	Execute cmd
	ShowInfo
	DoWindow/C U_moins
	slayer=slayertemp
End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot EFI..." "U+" 时调用此函数
Function Calcul_champincidentplus()
	NVAR long_onde,slayer
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde
	Variable interface=slayer
	Variable slayertemp=slayer

	// 弹出输入提示框
	Prompt interface, "Interface # :"
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", interface,alphamin,alphamax,nrj

	If (interface > numpnts(delta)-1)
		Abort "Interface doest not exist !"
	Endif

	slayer=interface
	long_onde=1239.97/nrj
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax

	// 主内容窗口
	DoWindow/K U_plus
	Make/N=1001/O/D Uplus
	SetScale/I x alpha_min,alpha_max,"", Uplus

	Uplus=magsqr(champincidentplus(x))
	
	Display Uplus
	ModifyGraph mirror=2, btLen=5, lsize=2, log(left)=1, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "|U\\B+\\M|\\S2"
	String cmd
	cmd="TextBox/C/N=text0/M \"Interface #"+num2str(interface)+"\""
	Execute cmd
	ShowInfo
	DoWindow/C U_plus
	slayer=slayertemp
End

//----------------------------------------------------------------------------------------------------------------------------------

// 点击 "Plot EFI..." "V-" 时调用此函数
Function Calcul_champincidentmoinsdown()
	NVAR long_onde,slayer
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde
	Variable interface=slayer
	Variable slayertemp=slayer

	// 弹出输入提示框
	Prompt interface, "Interface # :"
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", interface,alphamin,alphamax,nrj

	If (interface > numpnts(delta)-1)
		Abort "Interface doest not exist !"
	Endif

	slayer=interface
	long_onde=1239.97/nrj
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax

	// 主内容窗口
	DoWindow/K V_moins
	Make/N=1001/O/D Vmoins
	SetScale/I x alpha_min,alpha_max,"", Vmoins

	Vmoins=magsqr(champincidentmoinsdown(x))
	
	Display Vmoins
	ModifyGraph mirror=2, btLen=5, lsize=2, log(left)=1, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "|V\\B-\\M|\\S2"
	String cmd
	cmd="TextBox/C/N=text0/M/A=RB \"Interface #"+num2str(interface)+"\""
	Execute cmd
	ShowInfo
	DoWindow/C V_moins
	slayer=slayertemp
End

//----------------------------------------------------------------------------------------------------------------------------------
// 点击 "Plot EFI..." "V+" 时调用此函数
Function Calcul_champincidentplusdown()
	NVAR long_onde,slayer
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	Variable nrj=1239.97/long_onde
	Variable interface=slayer
	Variable slayertemp=slayer

	// 弹出输入提示框
	Prompt interface, "Interface # :"
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters", interface,alphamin,alphamax,nrj

	If (interface > numpnts(delta)-1)
		Abort "Interface doest not exist !"
	Endif

	slayer=interface
	long_onde=1239.97/nrj
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax

	// 主内容窗口
	DoWindow/K V_plus
	Make/N=1001/O/D Vplus
	SetScale/I x alpha_min,alpha_max,"", Vplus

	Vplus=magsqr(champincidentplusdown(x))
	
	Display Vplus
	ModifyGraph mirror=2, btLen=5, lsize=2, log(left)=1, fSize=14
	Label bottom "Grazing angle (�)"
	Label left "|V\\B+\\M|\\S2"
	String cmd
	cmd="TextBox/C/N=text0/M \"Interface #"+num2str(interface)+"\""
	Execute cmd
	ShowInfo
	DoWindow/C V_plus
	slayer=slayertemp
End

//----------------------------------------------------------------------------------------------------------------------------------
// 未用到
Function map1d2z_efi()
	NVAR long_onde,alphai_detec
	Variable nrj=1239.97/long_onde
	Variable angl=alphai_detec
	Variable depthmin=0
	Variable depthmax=round(sum(thickness,0,numpnts(thickness)-2)*4/3)
	
	Prompt angl,"Grazing angle (�):"
	Prompt depthmin,"Depth min. (nm):"
	Prompt depthmax,"Depth max. (nm):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters" angl,depthmin,depthmax,nrj

	long_onde=1239.97/nrj
	alphai_detec=angl
	Print "E =",nrj,"eV, Grazing angle =",angl,"�"
	Print ""

	DoWindow/K EFI_1d2z
	
	Make/O/D/N=201 efi1d2z
	SetScale/I x depthmin,depthmax,"", efi1d2z
	efi1d2z=calc_efi2z(angl,x)
		
	Display efi1d2z
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14
	ModifyGraph width=226.772,height=141.732
	Label bottom "Depth (nm)"
	Label left "Normalized EFI"
	SetAxis/A/E=1 left
	ShowInfo
	DoWindow/C EFI_1d2z
End

//----------------------------------------------------------------------------------------------------------------------------------
// 未用到
Function map1d2a_efi()
	NVAR long_onde,alphai_detec,slayer
	Variable nrj=1239.97/long_onde
	Variable prof=sum(thickness,0,slayer-1)
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	
	Prompt prof,"Depth (nm):"
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters" prof,alphamin,alphamax,nrj

	long_onde=1239.97/nrj
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax
	Print "E =",nrj,"eV, Depth =",prof,"nm"
	Print " "

	DoWindow/K EFI_1d2a
	
	Make/O/D/N=201 efi1d2a
	SetScale/I x alphamin,alphamax,"", efi1d2a
	efi1d2a=calc_efi2z(x,prof)
		
	Display efi1d2a
	ModifyGraph mirror=2, btLen=5, lsize=2, fSize=14
	ModifyGraph width=226.772,height=141.732
	Label bottom "Grazing angle (�)"
	Label left "Normalized EFI"
	SetAxis/A/E=1 left
	ShowInfo
	DoWindow/C EFI_1d2a
End

//----------------------------------------------------------------------------------------------------------------------------------
// 未用到
Function map2d_efi()
	NVAR long_onde,alphai_detec,alpha_min,alpha_max
	Variable nrj=1239.97/long_onde
	Variable depthmin=0
	Variable depthmax=round(sum(thickness,0,numpnts(thickness)-2)*4/3)
	Variable alphamin=NumVarOrDefault("alpha_min",0)
	Variable alphamax=NumVarOrDefault("alpha_max",1)
	
	Prompt alphamin,"Grazing angle min. (�):"
	Prompt alphamax,"Grazing angle max. (�):"
	Prompt depthmin,"Depth min. (nm):"
	Prompt depthmax,"Depth max. (nm):"
	Prompt nrj,"Energy (eV):"
	DoPrompt "Enter parameters" alphamin,alphamax,depthmin,depthmax,nrj

	long_onde=1239.97/nrj
	Variable/G alpha_min=alphamin
	Variable/G alpha_max=alphamax
	Print "E =",nrj,"eV"
	Print ""

	DoWindow/K EFI_2d
		
	Make/N=(200,200)/O/D efi2d
	SetScale/I x alphamin,alphamax,"", efi2d
	SetScale/I y depthmin,depthmax,"", efi2d
	efi2d=calc_efi2z(x,y)
		
	Display;AppendImage efi2d
	ModifyGraph fSize=14,btLen=5
	ModifyGraph width=226.772,height=141.732
	Label left "Depth (nm)"
	Label bottom "Grazing angle (�)"
	SetAxis/A/R left
	ModifyImage efi2d ctab= {0,*,BlueHot,1}
	ColorScale/C/N=text0/X=0.00/Y=4.00/F=0/A=RC/E image=efi2d,heightPct=100,width=10,lblMargin=-5,tickLen=5.00,fsize=14,prescaleExp=0,"Normalized EFI"
	ShowInfo
	DoWindow/C EFI_2d
End

//----------------------------------------------------------------------------------------------------------------------------------

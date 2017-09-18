#pragma rtGlobals=1		// Use modern global access method.

// 宏入口
Macro FitGISAXS_5()

	// 控制台输出信息
	Print "FitGISAXS_5 loaded - last update 31/05/2013 (david.babonneau@univ-poitiers.fr)"
	DoWindow/K Table0

	DoWindow/K NewGISAXS
	DoWindow/K cut
	DoWindow/K cut2d
	DoWindow/K Fit1d_parameters
	DoWindow/K Fit2d_parameters
	DoWindow/K Guinier_plot

	DoWindow/K Res_gisaxs2D
	DoWindow/K Fit_gisaxs2D
	DoWindow/K Sim_gisaxs2D
	DoWindow/K Sim_gisaxs1D

	DoWindow/K Size_distribution
	DoWindow/K Shape_distribution
	DoWindow/K Formfactor
	DoWindow/K Structurefactor
	DoWindow/K coef_reflection
	DoWindow/K coef_transmission
	DoWindow/K penetration
	DoWindow/K U_moins
	DoWindow/K U_plus
	DoWindow/K V_moins
	DoWindow/K V_plus
	DoWindow/K EFI_1d2z
	DoWindow/K EFI_1d2a
	DoWindow/K EFI_2d

	DoWindow/K Layer_parameters
	DoWindow/K Table_Layer_parameters
	DoWindow/K Fit_parameters
	DoWindow/K GISAXS_parameters
	
	KillWaves/A/Z
	Make/D/O W_coef

	// G后缀猜测为全局变量(跨文件)
	String/G MAstring="("
	
	Variable/G long_onde=1239.97/10000
	Variable/G alphai_detec=0.3
	Variable/G phi_detec=0
	Variable/G psi_detec=0
	Variable/G slayer=0
	Variable/G deltaLAY=0			//			Vacuum @ 10 keV
	Variable/G betaLAY=0
	Variable/G deltaNPs=1.9001E-05	//2.979e-5			Ag @ 10 keV
	Variable/G betaNPs=1.1833E-06 	//2.721e-6
	Variable/G deltaNPc=2.9912E-05	//2.979e-5			Au @ 10 keV
	Variable/G betaNPc=2.2073E-06	//2.721e-6

	Variable/G vectQx=0
	Variable/G vectQy=0
	Variable/G vectQz=0
	Variable/C/G vectQx_cmplx=0
	Variable/C/G vectQy_cmplx=0
	Variable/C/G vectQz_cmplx=0
	Variable/G sizeX=0
	Variable/G sizeY=0
	Variable/G sizeZ=0
	Variable/G IntegralResult=0
	Variable/C/G cIntegralResult=0

	Make/D/N=1/O delta,betta,thickness,roughness,nps
	delta[0]=4.8889E-06//4.89e-6			Si @ 10 keV
	betta[0]=7.3544E-08 //7.38e-8
	thickness[0]=inf
	roughness[0]=0
	nps[0]=0

	Make/T/N=18/O textWave0
	textWave0="None"
	textWave0[0]="Background (B)"
	textWave0[1]="Scale factor (k)"
	textWave0[2]="D\\By\\M (nm)"
	textWave0[6]="H/D\\By\\M ratio"

	Make/D/N=18/O coef,coefhold
	coefhold=1
	coef=-1
	coef[0]=0
	coef[1]=1
	coef[2]=5
	coef[6]=1
	
	Variable/G Dmin:=max(1e-6,coef[2]-2*coef[3])//1e-6
	Variable/G Dmax:=coef[2]+3*coef[3]//15

	Make/T/N=8/O textWave1
	textWave1[0]="Cut position (dq)"
	textWave1[1]="Cut angle (dphi)"
	textWave1[2]="Random organization"
	textWave1[3]="Born approximation"
	textWave1[4]="Spheroid"
	textWave1[5]="Log-normal"
	textWave1[6]="Monodisperse approximation"
	textWave1[7]="Constant"

	// 执行某些操作
	Execute/P/Q/Z "INSERTINCLUDE  \"Form_"+textWave1[4]+"\""
	Execute/P/Q/Z "INSERTINCLUDE  \"Structure_"+textWave1[2]+"\""
	Execute/P/Q/Z "INSERTINCLUDE  \"Sizedist_"+textWave1[5]+"\""
	Execute/P/Q/Z "INSERTINCLUDE  \"Shapedist_"+textWave1[7]+"\""
	Execute/P/Q/Z "INSERTINCLUDE  \"Form2_"+textWave1[3]+"\""
	Execute/P/Q/Z "INSERTINCLUDE  \"LMA_"+textWave1[6]+"\""

	Execute/P/Q/Z "INSERTINCLUDE  \"FitParameters5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"LayerParameters5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"EFI Functions5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"GISAXS menu5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"GISAXSParameters5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"LMA fit5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"sim GISAXS5\""
	Execute/P/Q/Z "INSERTINCLUDE  \"Import CCD5\""
	
//	Execute/P/Q/Z "INSERTINCLUDE  \"load scan esrf\""

	Execute/P/Q/Z "COMPILEPROCEDURES "

	Execute/P/Q/Z "askGISAXSparameters()"
	Execute/P/Q/Z "askFITparameters()"
	Execute/P/Q/Z "askLAYERparameters()"
	
	// 绘制提示窗口
	DoWindow/K FitGISAXS_5
	NewPanel/M/W=(1,7,15,10.4)				//	W=(left,top,right,bottom)
	Dowindow/C FitGISAXS_5
	ModifyPanel/W=FitGISAXS_5 cbRGB=(65280,54528,48896)
	DrawText 20,30,"If you use FitGISAXS to analyze GISAXS data, please acknowledge by citing the reference:"
	SetDrawEnv fstyle= 2
	DrawText 20,70,"FitGISAXS: software package for modelling and analysis of GISAXS data using IGOR Pro,"
	SetDrawEnv fstyle= 1
	DrawText 40,100,"D. Babonneau, J. Appl. Crystallogr. 43 (2010) 929-936."
	Button button0 title="OK",proc=ButtonProcOK,pos={450,100}

End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------

Function ButtonProcOK(ctrlName) : ButtonControl
	String ctrlName

	DoWindow/K FitGISAXS_5
End

//-----------------------------------------------------------------------------------------------------------------------------------------------------------
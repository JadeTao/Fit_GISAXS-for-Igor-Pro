#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// DWBA Holes layer
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,slayer
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Wave/D delta,betta,thickness
	Variable/C formfactorcmplx,k_i,k_f,formfactorcmplx1,formfactorcmplx2
	
	//k_i=-2*pi/long_onde*sqrt((1-delta[slayer-1]-sqrt(-1)*betta[slayer-1])^2-(cos(alphai_detec*pi/180))^2)
	k_i=-2*pi/long_onde*sqrt((1)^2-(cos(alphai_detec*pi/180))^2)
	k_f=2*pi/long_onde*sqrt((1-delta[slayer-1]-sqrt(-1)*betta[slayer-1])^2-(cos(alphafdetec*pi/180))^2)
	

	formfactorcmplx=champincidentmoins(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f-k_i,D_y,D_z)
	formfactorcmplx+=champincidentplus(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f+k_i,D_y,D_z)
	formfactorcmplx+=champincidentmoins(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z)
	formfactorcmplx+=champincidentplus(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z)

	Return magsqr(formfactorcmplx)*(sign(alphafdetec)+1)/2

	//formfactorcmplx1=champincidentmoins(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f-k_i,D_y,D_z)
	//formfactorcmplx1+=champincidentplus(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f+k_i,D_y,D_z)
	//formfactorcmplx1+=champincidentmoins(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z)
	//formfactorcmplx1+=champincidentplus(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z)

//		formfactorcmplx1=formfactorcmplx1*((1-1.094E-05-sqrt(-1)*1.565E-07)^2-(1-2.979e-5-sqrt(-1)*2.721e-6)^2)//			AS
//	formfactorcmplx1=formfactorcmplx1*((1-1.998E-05-sqrt(-1)*1.823E-06)^2-(1-2.979e-5-sqrt(-1)*2.721e-6)^2)//			AS
	//	formfactorcmplx1=formfactorcmplx1*((1-6.653E-06-sqrt(-1)*6.369E-08)^2-(1-1.9001E-05-sqrt(-1)*1.1833E-06)^2)//			SAS
	
//	wave/d coef
//	variable xi=coef[8]
//	k_i=	-2*pi/long_onde*sqrt((1)^2-(cos(alphai_detec*pi/180))^2)
//	k_f=	2*pi/long_onde*sqrt((1)^2-(cos(alphafdetec*pi/180))^2)
//	formfactorcmplx2=Form_factor(q_x,q_y,k_f-k_i,D_y,D_z*xi)		
//	formfactorcmplx2+=calcul_reflecto(alphai_detec)*Form_factor(q_x,q_y,k_f+k_i,D_y,D_z*xi)
//	formfactorcmplx2+=calcul_reflecto(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z*xi)
//	formfactorcmplx2+=calcul_reflecto(alphai_detec)*calcul_reflecto(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z*xi)

//		formfactorcmplx2=formfactorcmplx2*((1-3.554E-06-sqrt(-1)*5.33E-08)^2-(1-1.065e-5-sqrt(-1)*1.598e-7)^2)//			AS
//	formfactorcmplx2=formfactorcmplx2*((1-5.326E-06-sqrt(-1)*7.99E-08)^2-(1-1.065e-5-sqrt(-1)*1.598e-7)^2)//			AS
	//	formfactorcmplx2=formfactorcmplx2*((1-2.147E-06-sqrt(-1)*2.097E-08)^2-(1-6.442e-6-sqrt(-1)*6.29e-8)^2)/2//			SAS
	
//	Return magsqr(formfactorcmplx1)+magsqr(formfactorcmplx2)+2*real(r2polar(formfactorcmplx1))*real(r2polar(formfactorcmplx2))*cos(q_z*sum(thickness,0,slayer-1))
//	Return magsqr(formfactorcmplx1)+magsqr(formfactorcmplx2)//+2*real(r2polar(formfactorcmplx1))*real(r2polar(formfactorcmplx2))*cos(q_z*thickness[0])
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
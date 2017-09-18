#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// DWBA Correlated roughness
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,slayer,deltaNPs,betaNPs,deltaLAY,betaLAY
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Wave/D delta,betta,thickness,coef
	Variable/C formfactorcmplx,k_i,k_f,formfactorcmplx1,formfactorcmplx2
	
	k_i=-2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphai_detec*pi/180))^2)
	k_f=2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphafdetec*pi/180))^2)

	formfactorcmplx1=champincidentmoins(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f-k_i,D_y,D_z)
	formfactorcmplx1+=champincidentplus(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f+k_i,D_y,D_z)
	formfactorcmplx1+=champincidentmoins(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z)
	formfactorcmplx1+=champincidentplus(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z)

	formfactorcmplx1=(2*pi/long_onde)^2/(4*pi)*((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)*formfactorcmplx1	
	
	k_i=	-2*pi/long_onde*sqrt((1)^2-(cos(alphai_detec*pi/180))^2)
	k_f=	2*pi/long_onde*sqrt((1)^2-(cos(alphafdetec*pi/180))^2)

	formfactorcmplx2=Form_factor(q_x,q_y,k_f-k_i,D_y*coef[12],D_z*coef[13])		
	formfactorcmplx2+=calcul_reflecto(alphai_detec)*Form_factor(q_x,q_y,k_f+k_i,D_y*coef[12],D_z*coef[13])
	formfactorcmplx2+=calcul_reflecto(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y*coef[12],D_z*coef[13])
	formfactorcmplx2+=calcul_reflecto(alphai_detec)*calcul_reflecto(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y*coef[12],D_z*coef[13])

//	formfactorcmplx2=(2*pi/long_onde)^2/(4*pi)*((1-delta[0]-sqrt(-1)*betta[0])^2-(1-delta[0]/2-sqrt(-1)*betta[0]/2)^2)*formfactorcmplx2
	formfactorcmplx2=(2*pi/long_onde)^2/(4*pi)*((1-delta[0]-sqrt(-1)*betta[0])^2-(1)^2)*formfactorcmplx2

	Variable bool=(sign(alphafdetec)+1)/2
	Return (magsqr(formfactorcmplx1)+magsqr(formfactorcmplx2)+2*sqrt(magsqr(formfactorcmplx1))*sqrt(magsqr(formfactorcmplx2))*cos(q_z*sum(thickness,0,slayer-2)))*bool
//	Return (magsqr(formfactorcmplx1)+magsqr(formfactorcmplx2)+2*sqrt(magsqr(formfactorcmplx1))*sqrt(magsqr(formfactorcmplx2))*cos(-q_y*coef[2]*coef[4]/4+q_z*sum(thickness,0,slayer-2)))*bool
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z)
	Variable q_x,q_y,q_z,D_y,D_z

	Return 1
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
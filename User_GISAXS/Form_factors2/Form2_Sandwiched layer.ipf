#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// DWBA Sandwiched layer
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,slayer,deltaNPs,betaNPs,deltaLAY,betaLAY
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Wave/D delta,betta,thickness
	Variable/C k_i,k_f,formfactorcmplx
		
	k_i=-2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphai_detec*pi/180))^2)
	k_f=2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphafdetec*pi/180))^2)

	Variable z0=(1/calcul_profpen(alphai_detec,delta[slayer-1],betta[slayer-1])+1/calcul_profpen(alphafdetec,delta[slayer-1],betta[slayer-1]))^(-1)
	Variable y0=(1/calcul_profpen(alphai_detec,delta[slayer-1],betta[slayer-1])-1/calcul_profpen(alphafdetec,delta[slayer-1],betta[slayer-1]))^(-1)
	Variable/C formfactorcmplx1,formfactorcmplx2,formfactorcmplx3,formfactorcmplx4
	Variable formfactor1,formfactor2,formfactor3,formfactor4
	
	formfactorcmplx1=champincidentmoins(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f-k_i,D_y,D_z)
	formfactorcmplx2=champincidentplus(alphai_detec)*champincidentmoins(alphafdetec)*Form_factor(q_x,q_y,k_f+k_i,D_y,D_z)
	formfactorcmplx3=champincidentmoins(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z)
	formfactorcmplx4=champincidentplus(alphai_detec)*champincidentplus(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z)

	formfactor1=magsqr(formfactorcmplx1)*z0/thickness[slayer-1]*(exp(thickness[slayer-1]/z0)-1)
	formfactor2=magsqr(formfactorcmplx2)*y0/thickness[slayer-1]*(1-exp(-thickness[slayer-1]/y0))
	formfactor3=magsqr(formfactorcmplx3)*y0/thickness[slayer-1]*(exp(thickness[slayer-1]/y0)-1)
	formfactor4=magsqr(formfactorcmplx4)*z0/thickness[slayer-1]*(1-exp(-thickness[slayer-1]/z0))

	Return (2*pi/long_onde)^4/(16*pi)^2*magsqr((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)*(formfactor1+formfactor2+formfactor3+formfactor4)*(sign(alphafdetec)+1)/2
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z)
	Variable q_x,q_y,q_z,D_y,D_z

	Return 1
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

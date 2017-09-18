#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// DWBA Buried layer
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,slayer,deltaNPs,betaNPs,deltaLAY,betaLAY
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Wave/D delta,betta,thickness
	Variable/C k_i,k_f,formfactorcmplx
		
	k_i=-2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphai_detec*pi/180))^2)
	k_f=2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphafdetec*pi/180))^2)

	Variable z0=(1/calcul_profpen(alphai_detec,delta[slayer-1],betta[slayer-1])+1/calcul_profpen(alphafdetec,delta[slayer-1],betta[slayer-1]))^(-1)
	Variable z1=(sum(thickness,0,slayer-2)+sign(slayer-2)*sum(thickness,0,slayer-2))/2	// z1=0 if slayer-2<0 and z1=z1 if slayer-2>=0
	Variable z2=sum(thickness,0,slayer-1)
	Variable t0=Calcul_transmission(alphai_detec,delta[slayer-1],betta[slayer-1])*Calcul_transmission(alphafdetec,delta[slayer-1],betta[slayer-1])

	formfactorcmplx=Form_factor(q_x,q_y,k_f-k_i,D_y,D_z)

	Return (2*pi/long_onde)^4/(16*pi)^2*magsqr((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)*t0*z0/thickness[slayer-1]*(exp(-z1/z0)-exp(-z2/z0))*magsqr(formfactorcmplx)*(sign(alphafdetec)+1)/2
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z)
	Variable q_x,q_y,q_z,D_y,D_z

	Return 1
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
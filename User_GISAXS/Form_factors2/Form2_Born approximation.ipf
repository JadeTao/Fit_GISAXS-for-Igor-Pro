#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// Born Approximation
	Variable q_x,q_y,q_z,D_y,D_z

	Return magsqr(Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z)	// Born Approximation
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,slayer,deltaNPs,betaNPs,deltaLAY,betaLAY
	Wave/D delta,betta
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Variable/C formfactorcmplx
		
	formfactorcmplx=Form_factor(q_x,q_y,q_z,D_y,D_z)

	Variable bool=(sign(alphafdetec)+1)/2
	Return (2*pi/long_onde)^2/(4*pi)*((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)*formfactorcmplx*bool
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// DWBA Surface holes
	Variable q_x,q_y,q_z,D_y,D_z

	Return magsqr(Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor_amplitude(q_x,q_y,q_z,D_y,D_z)	// DWBA Surface holes
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,slayer,deltaNPs,betaNPs,deltaLAY,betaLAY
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Wave/D delta,betta,thickness
	Variable/C formfactorcmplx,k_i,k_f
	
	k_i=-2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphai_detec*pi/180))^2)
	k_f=2*pi/long_onde*sqrt((1-deltaLAY-sqrt(-1)*betaLAY)^2-(cos(alphafdetec*pi/180))^2)

slayer-=1
	formfactorcmplx=champincidentmoinsdown(alphai_detec)*champincidentmoinsdown(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z)
	formfactorcmplx+=champincidentplusdown(alphai_detec)*champincidentmoinsdown(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z)
	formfactorcmplx+=champincidentmoinsdown(alphai_detec)*champincidentplusdown(alphafdetec)*Form_factor(q_x,q_y,+k_f+k_i,D_y,D_z)
	formfactorcmplx+=champincidentplusdown(alphai_detec)*champincidentplusdown(alphafdetec)*Form_factor(q_x,q_y,+k_f-k_i,D_y,D_z)
slayer+=1

	Variable bool=(sign(alphafdetec)+1)/2
	Return (2*pi/long_onde)^2/(4*pi)*((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)*formfactorcmplx*bool
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
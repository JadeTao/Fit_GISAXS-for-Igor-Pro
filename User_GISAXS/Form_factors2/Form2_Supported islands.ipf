#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Form_factor2(q_x,q_y,q_z,D_y,D_z)	// DWBA Supported islands
	Variable q_x,q_y,q_z,D_y,D_z

	Return magsqr(Form_factor_Amplitude(q_x,q_y,q_z,D_y,D_z))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor_Amplitude(q_x,q_y,q_z,D_y,D_z)	// DWBA Supported islands
	Variable q_x,q_y,q_z,D_y,D_z
	NVAR long_onde,alphai_detec,deltaNPs,betaNPs
	Variable alphafdetec=asin(long_onde/2/pi*q_z-sin(alphai_detec*pi/180))*180/pi
	Variable/C formfactorcmplx,k_i,k_f
	
	k_i=	-2*pi/long_onde*sqrt((1)^2-(cos(alphai_detec*pi/180))^2)
	k_f=	2*pi/long_onde*sqrt((1)^2-(cos(alphafdetec*pi/180))^2)
	
	formfactorcmplx=Form_factor(q_x,q_y,k_f-k_i,D_y,D_z)		
	formfactorcmplx+=calcul_reflecto(alphai_detec)*Form_factor(q_x,q_y,k_f+k_i,D_y,D_z)
	formfactorcmplx+=calcul_reflecto(alphafdetec)*Form_factor(q_x,q_y,-k_f-k_i,D_y,D_z)
	formfactorcmplx+=calcul_reflecto(alphai_detec)*calcul_reflecto(alphafdetec)*Form_factor(q_x,q_y,-k_f+k_i,D_y,D_z)

	Variable bool=(sign(alphafdetec)+1)/2
	Return (2*pi/long_onde)^2/(4*pi)*((1-deltaNPs-sqrt(-1)*betaNPs)^2-1)*formfactorcmplx*bool
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
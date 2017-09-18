#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Fit_GISAXS(q_x,q_y,q_z)		// Monodisperse approximation (MA)
	Variable q_x,q_y,q_z
	Wave/D coef

	Variable D=coef[2]
	Variable H=D*Shape_dist(coef,D)
	Variable Dhs=D*coef[4]
	Variable Hhs=H*coef[4]
	
	Return abs(coef[0])+abs(coef[1])*Form_factor2(q_x,q_y,q_z,D,H)*Structure_factor(q_x,q_y,q_z,Dhs,Hhs,coef[5])
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

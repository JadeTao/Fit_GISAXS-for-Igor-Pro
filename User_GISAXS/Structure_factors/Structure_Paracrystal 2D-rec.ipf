#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Structure_Factor(q_x,q_y,q_z,Dy_hs,Dz_hs,sigma)	// 
	Variable q_x,q_y,q_z,Dy_hs,Dz_hs,sigma
	Wave/D coef
	Variable vLambda0=1e3		// correlation length (nm)
	Variable q_p=sqrt(q_x^2+q_y^2)
	Variable vA,vB,sigma_x,sigma_y,vPhi_x,vPhi_y,vQscalA,vQscalB
	
	vA=coef[16]*Dy_hs		// pas du r�seau dans la direction x
	vB=Dy_hs				// pas du r�seau dans la direction y
	sigma_x=coef[17]*sigma	// �cart-type dans la direction x
	sigma_y=sigma			// �cart-type dans la direction y

	vPhi_x=exp(-q_p^2*sigma_x^2/2)*exp(-vA/vLambda0)
	vPhi_y=exp(-q_p^2*sigma_y^2/2)*exp(-vB/vLambda0)

	//------------------------------------------------------------------------------------------------

	vQscalA=q_x*vA			// q_para . a (dans la direction x)
	vQscalB=q_y*vB			// q_para . b (dans la direction y)
	
	Return (1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))
	
	//------------------------------------------------------------------------------------------------
//	Variable returntemp		// Paracrystal 2D Centered rectangular lattice

//	vQscalA=q_y*vB
//	vQscalB=q_y*vB/2+q_x*vA/2
//	returntemp=(1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))

//	vQscalA=q_y*vB/2+q_x*vA/2
//	vQscalB=-q_y*vB/2+q_x*vA/2
//	returntemp+=(1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))

//	vQscalA=-q_y*vB/2+q_x*vA/2
//	vQscalB=-q_y*vB
//	returntemp+=(1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))

//	Return returntemp/3

End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

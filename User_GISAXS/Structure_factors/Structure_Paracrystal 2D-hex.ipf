#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Structure_Factor(q_x,q_y,q_z,Dy_hs,Dz_hs,sigma)	// Paracrystal 2D Hexagonal lattice
	Variable q_x,q_y,q_z,Dy_hs,Dz_hs,sigma
	Variable vLambda0=1e3		// correlation length (nm)
	Variable q_p=sqrt(q_x^2+q_y^2)
	Variable vA,vB,sigma_x,sigma_y,vPhi_x,vPhi_y,vQscalA,vQscalB
	
	vA=Dy_hs							// pas du réseau dans la direction x
	vB=Dy_hs							// pas du réseau dans la direction y
	sigma_x=sigma						// écart-type dans la direction x
	sigma_y=sigma						// écart-type dans la direction x
	vPhi_x=exp(-q_p^2*sigma_x^2/2)*exp(-vA/vLambda0)
	vPhi_y=exp(-q_p^2*sigma_y^2/2)*exp(-vB/vLambda0)

//------------------------------------------------------------------------------------------------
	Variable returntemp

	vQscalA=q_y*vA
	vQscalB=q_y*vA/2+q_x*vA*sqrt(3)/2
	returntemp=(1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))

	Return returntemp

//	vQscalA=q_y*vA/2+q_x*vA*sqrt(3)/2
//	vQscalB=-q_y*vA/2+q_x*vA*sqrt(3)/2
//	returntemp+=(1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))

//	vQscalA=-q_y*vA/2+q_x*vA*sqrt(3)/2
//	vQscalB=-q_y*vA
//	returntemp+=(1-vPhi_x^2)/(1+vPhi_x^2-2*vPhi_x*cos(vQscalA))*(1-vPhi_y^2)/(1+vPhi_y^2-2*vPhi_y*cos(vQscalB))

//	Return returntemp/3
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

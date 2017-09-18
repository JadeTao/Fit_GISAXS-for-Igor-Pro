#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Structure_Factor(q_x,q_y,q_z,Dy_hs,Dz_hs,sigma)	// Paracrystal 1D
	Variable q_x,q_y,q_z,Dy_hs,Dz_hs,sigma
	Variable vLambda0=1e3		// correlation length (nm)
	Variable vPhi=exp(-q_y^2*sigma^2/2)*exp(-Dy_hs/vLambda0)

	Return (1-vPhi^2)/(1+vPhi^2-2*vPhi*cos(q_y*Dy_hs))

//	Variable/C vPk=vPhi*exp(sqrt(-1)*q_y*Dy_hs)
//	Return real((1+vPk)/(1-vPk))
//	Return 1+2*real(vPk/(1-vPk))

//	Variable vNk=1e10
//	Return real(2*(1-vPk^vNk)/(1-vPk)-1)

//	Return (1-exp(-(q_x^2+q_y^2)*sigma^2))/(1+exp(-(q_x^2+q_y^2)*sigma^2)-2*exp(-1/2*(q_x^2+q_y^2)*sigma^2)*cos(sqrt(q_x^2+q_y^2)*Dy_hs))
//	Return (1-exp(-(q_x^2)*sigma^2))/(1+exp(-(q_x^2)*sigma^2)-2*exp(-1/2*(q_x^2)*sigma^2)*cos(q_x*Dy_hs))
//	Return (1-exp(-(q_y^2)*sigma^2))/(1+exp(-(q_y^2)*sigma^2)-2*exp(-1/2*(q_y^2)*sigma^2)*cos(q_y*Dy_hs))
	
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

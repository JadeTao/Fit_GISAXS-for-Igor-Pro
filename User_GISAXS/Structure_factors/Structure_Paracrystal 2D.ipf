#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Structure_Factor(q_x,q_y,q_z,Dy_hs,Dz_hs,sigma)	// Paracrystal 1D
	Variable q_x,q_y,q_z,Dy_hs,Dz_hs,sigma
	
	Variable sigma2=2
	Variable Dy_hs2=7.5
	
//	Return (1-exp(-(q_y^2)*sigma^2))/(1+exp(-(q_y^2)*sigma^2)-2*exp(-1/2*(q_y^2)*sigma^2)*cos(q_y*Dy_hs))*(1-exp(-(q_x^2)*sigma2^2))/(1+exp(-(q_x^2)*sigma2^2)-2*exp(-1/2*(q_x^2)*sigma2^2)*cos(q_x*Dy_hs2))
//	Return (1-exp(-(q_x^2)*sigma2^2))/(1+exp(-(q_x^2)*sigma2^2)-2*exp(-1/2*(q_x^2)*sigma2^2)*cos(q_x*Dy_hs2))
//	Return (1-exp(-(q_y^2)*sigma2^2))/(1+exp(-(q_y^2)*sigma2^2)-2*exp(-1/2*(q_y^2)*sigma2^2)*cos(q_y*Dy_hs2))

	Variable q_p=sqrt(q_x^2+q_y^2)
//	Variable/C xi1=exp(-sqrt(-1)*Dy_hs*q_y)*exp(-sigma^2*q_y^2/2)
//	Variable/C xi2=exp(-sqrt(-1)*Dy_hs2*q_x)*exp(-sigma2^2*q_x^2/2)

	Variable a1x=Dy_hs*sqrt(3)/2
	Variable a1y=-Dy_hs/2
	Variable a2x=Dy_hs*sqrt(3)/2
	Variable a2y=Dy_hs/2
//	Variable a1x=Dy_hs
//	Variable a1y=0
//	Variable a2x=-Dy_hs/2
//	Variable a2y=Dy_hs*sqrt(3)/2
	Variable/C xi1=exp(-sqrt(-1)*(a1x*q_x+a1y*q_y))*exp(-sigma^2*q_p^2/2)
	Variable/C xi2=exp(-sqrt(-1)*(a2x*q_x+a2y*q_y))*exp(-sigma^2*q_p^2/2)

	Return (1+2*real(xi1/(1-xi1)))*(1+2*real(xi2/(1-xi2)))	
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

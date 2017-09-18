#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Structure_Factor(q_x,q_y,q_z,Dy_hs,Dz_hs,eta_hs)	// 2D short-range organization
	Variable q_x,q_y,q_z,Dy_hs,Dz_hs,eta_hs
	Variable q_p,G
	
	q_p=sqrt(q_x^2+q_y^2)
	G=((1+2*eta_hs)^2/(1-eta_hs)^4)*(sin(Dy_hs*q_p)-Dy_hs*q_p*cos(Dy_hs*q_p))/(Dy_hs*q_p)^2+(-6*eta_hs*(1+eta_hs/2)^2/(1-eta_hs)^4)*(2*Dy_hs*q_p*sin(Dy_hs*q_p)+(2-(Dy_hs*q_p)^2)*cos(Dy_hs*q_p)-2)/(Dy_hs*q_p)^3+(eta_hs*((1+2*eta_hs)^2/(1-eta_hs)^4)/2)*(-(Dy_hs*q_p)^4*cos(Dy_hs*q_p)+4*((3*(Dy_hs*q_p)^2-6)*cos(Dy_hs*q_p)+((Dy_hs*q_p)^3-6*Dy_hs*q_p)*sin(Dy_hs*q_p)+6))/(Dy_hs*q_p)^5
	Return 1/(1+24*eta_hs*G/(Dy_hs*q_p))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

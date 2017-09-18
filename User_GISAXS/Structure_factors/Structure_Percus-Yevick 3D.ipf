#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Structure_Factor(q_x,q_y,q_z,Dy_hs,Dz_hs,eta_hs)	// Volume short-range organization
	Variable q_x,q_y,q_z,Dy_hs,Dz_hs,eta_hs
	NVAR psi_detec

	Variable gg=2*sqrt((sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*Dy_hs/2)^2+((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*Dz_hs/2)^2)
	Variable G=((1+2*eta_hs)^2/(1-eta_hs)^4)*(sin(gg)-gg*cos(gg))/(gg)^2+(-6*eta_hs*(1+eta_hs/2)^2/(1-eta_hs)^4)*(2*gg*sin(gg)+(2-(gg)^2)*cos(gg)-2)/(gg)^3+(eta_hs*((1+2*eta_hs)^2/(1-eta_hs)^4)/2)*(-(gg)^4*cos(gg)+4*((3*(gg)^2-6)*cos(gg)+((gg)^3-6*gg)*sin(gg)+6))/(gg)^5

	Return 1/(1+24*eta_hs*G/(gg))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

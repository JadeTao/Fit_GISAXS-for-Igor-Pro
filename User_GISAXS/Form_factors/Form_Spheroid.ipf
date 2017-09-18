#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// spheroid {diameter D_y, height D_z, volume (pi/6)*D_y^2*D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR psi_detec
	
	Variable/C kk=sqrt((sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*D_y/2)^2+((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*D_z/2)^2)
	
	Return (pi/6*D_y^2*D_z)*3*(sin(kk)-(kk)*cos(kk))/(kk)^3*exp(sqrt(-1)*q_z*(D_y*D_z/2/sqrt((D_y*cos(psi_detec*pi/180))^2+(D_z*sin(psi_detec*pi/180))^2)))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
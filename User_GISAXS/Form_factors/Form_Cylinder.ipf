#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)		// cylinder {diameter D_y, height D_z, volume (pi/4)*D_y^2*D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR psi_detec

	Return 2*pi*(D_y/2)^2*D_z*bessel(sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*D_y/2)*sinc((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*D_z/2)*exp(sqrt(-1)*q_z*(D_z/2*cos(psi_detec*pi/180)+D_y/2*sqrt((sin(psi_detec*pi/180))^2)))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

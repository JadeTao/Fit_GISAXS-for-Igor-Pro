#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)		// tetrahedron
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	Wave/D coef

	Variable q1=0.5*((sqrt(3)*q_y-(-q_x))/tan(coef[14]*pi/180)-q_z)
	Variable q2=0.5*((sqrt(3)*q_y+(-q_x))/tan(coef[14]*pi/180)+q_z)
	Variable q3=0.5*((2*(-q_x))/tan(coef[14]*pi/180)-q_z)
	Variable L1=2*tan(coef[14]*pi/180)*D_y/2/sqrt(3)-D_z
	
	Return D_z/sqrt(3)/q_y/(q_y^2-3*(-q_x)^2)*exp(sqrt(-1)*q_z*d_y/2*tan(coef[14]*pi/180)/sqrt(3))*(-(q_y+sqrt(3)*(-q_x))*sinc(q1*D_z)*exp(sqrt(-1)*q1*L1)+(-q_y+sqrt(3)*(-q_x))*sinc(q2*D_z)*exp(-sqrt(-1)*q2*L1)+2*q_y*sinc(q3*D_z)*exp(sqrt(-1)*q3*L1))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

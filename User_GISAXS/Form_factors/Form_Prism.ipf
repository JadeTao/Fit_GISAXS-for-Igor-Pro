#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)		// prism
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z

//	Return 2*sqrt(3)*exp(-sqrt(-1)*q_y*D_y/2/sqrt(3))/(q_x*(q_x^2-3*q_y^2))*(q_x*exp(sqrt(-1)*q_y*D_y/2*sqrt(3))-q_x*cos(q_x*D_y/2)-sqrt(-1)*sqrt(3)*q_y*sin(q_x*D_y/2))*sinc(q_z*D_z/2)*exp(sqrt(-1)*q_z*D_z/2)
	Return 2*sqrt(3)*exp(-sqrt(-1)*(-q_x)*D_y/2/sqrt(3))/(q_y*(q_y^2-3*(-q_x)^2))*(q_y*exp(sqrt(-1)*(-q_x)*D_y/2*sqrt(3))-q_y*cos(q_y*D_y/2)-sqrt(-1)*sqrt(3)*(-q_x)*sin(q_y*D_y/2))*sinc(q_z*D_z/2)*exp(sqrt(-1)*q_z*D_z/2)
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

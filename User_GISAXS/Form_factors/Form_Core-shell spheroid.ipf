#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)		// cylinder {diameter D_y, height D_z, volume (pi/4)*D_y^2*D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	Wave/D coef
	NVAR psi_detec,deltaLAY,betaLAY,deltaNPs,betaNPs,deltaNPc,betaNPc

	Variable/C formfactorcmplx
	Variable/C tau=((1-deltaNPc-sqrt(-1)*betaNPc)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)/((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)

	Variable/C kk
	
	kk=sqrt((sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*D_y/2)^2+((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*D_z/2)^2)
	formfactorcmplx=(1-tau)*(pi/6*D_y^2*D_z)*3*(sin(kk)-(kk)*cos(kk))/(kk)^3//*exp(sqrt(-1)*q_z*(D_y*D_z/2/sqrt((D_y*cos(psi_detec*pi/180))^2+(D_z*sin(psi_detec*pi/180))^2)))
	
	D_y+=2*coef[8]
	D_z+=2*coef[8]
	kk=sqrt((sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*D_y/2)^2+((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*D_z/2)^2)
	formfactorcmplx+=tau*(pi/6*D_y^2*D_z)*3*(sin(kk)-(kk)*cos(kk))/(kk)^3//*exp(sqrt(-1)*q_z*(D_y*D_z/2/sqrt((D_y*cos(psi_detec*pi/180))^2+(D_z*sin(psi_detec*pi/180))^2)))
	
	Return formfactorcmplx*exp(sqrt(-1)*q_z*(D_y*D_z/2/sqrt((D_y*cos(psi_detec*pi/180))^2+(D_z*sin(psi_detec*pi/180))^2)))
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------


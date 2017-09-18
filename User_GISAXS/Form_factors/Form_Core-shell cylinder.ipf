#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)		// Core-shell cylinder {core diameter D_y, core height D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	Wave/D coef
	NVAR psi_detec,deltaLAY,betaLAY,deltaNPs,betaNPs,deltaNPc,betaNPc

	Variable/C formfactorcmplx
	Variable/C tau=((1-deltaNPc-sqrt(-1)*betaNPc)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)/((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)

	formfactorcmplx=(1-tau)*2*pi*(D_y/2)^2*D_z*bessel(sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*D_y/2)*sinc((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*D_z/2)*exp(sqrt(-1)*q_z*(D_z/2*cos(psi_detec*pi/180)+D_y/2*sqrt((sin(psi_detec*pi/180))^2)))
	formfactorcmplx+=tau*2*pi*(D_y/2+coef[8])^2*(D_z+coef[8])*bessel(sqrt(q_x^2+(q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180))^2)*(D_y/2+coef[8]))*sinc((-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180))*(D_z+coef[8])/2)*exp(sqrt(-1)*q_z*((D_z+coef[8])/2*cos(psi_detec*pi/180)+(D_y/2+coef[8])*sqrt((sin(psi_detec*pi/180))^2)))

	Return formfactorcmplx
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

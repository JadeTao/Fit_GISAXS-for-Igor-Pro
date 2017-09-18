#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// Ellipsoid {length D_x, diameter D_y, height D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	NVAR sizeX,sizeY,sizeZ,psi_detec,phi_detec
	Wave/D coef
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180)
	vectQz_cmplx=-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180)
	sizeX=coef[14]*D_y
	sizeY=D_y
	sizeZ=D_z
	cIntegralResult=Integrate1D(complexFormFactorFunction,0,D_z/2,2)*exp(sqrt(-1)*q_z*(D_y*D_z/2/sqrt((D_y*cos(psi_detec*pi/180))^2+(D_z*sin(psi_detec*pi/180))^2)))
	Return cIntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeX,sizeY,sizeZ
	Variable Rz=sizeX/2*sqrt(1-4*inZ^2/sizeZ^2)	
	Variable Wz=sizeY/2*sqrt(1-4*inZ^2/sizeZ^2)	
	Variable/C result=4*pi*Rz*Wz*bessel(sqrt(vectQx_cmplx^2*Rz^2+vectQy_cmplx^2*Wz^2))*cos(vectQz_cmplx*inZ)

	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

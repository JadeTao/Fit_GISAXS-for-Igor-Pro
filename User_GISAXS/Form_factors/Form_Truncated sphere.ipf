#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// Truncated sphere {diameter D_y, height D_z}	D_y/2 < D_z < D_y
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	NVAR sizeY,sizeZ,psi_detec
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180)
	vectQz_cmplx=-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180)
	sizeY=D_y
	sizeZ=D_z
	Variable dzmin=D_y/2*(sign(abs(psi_detec*pi/180)-pi/2+asin(2*D_z/D_y-1))+1)/2+D_y/2*sin(asin(2*D_z/D_y-1)+abs(psi_detec*pi/180))*(sign(pi/2-asin(2*D_z/D_y-1)-abs(psi_detec*pi/180))+1)/2
	cIntegralResult=Integrate1D(complexFormFactorFunction,D_y/2-D_z,D_y/2,2)*exp(sqrt(-1)*q_z*dzmin)
	Return cIntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeY,sizeZ
	Variable/C result
	result=2*pi*((sizeY/2)^2-inZ^2)*bessel(sqrt(vectQx_cmplx^2+vectQy_cmplx^2)*sqrt((sizeY/2)^2-inZ^2))*exp(-sqrt(-1)*vectQz_cmplx*inZ)
	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
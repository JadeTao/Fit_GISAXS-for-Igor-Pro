#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// hemispheroid {diameter D_y, height D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z 
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	NVAR sizeY,sizeZ,psi_detec
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y*cos(psi_detec*pi/180)+q_z*sin(psi_detec*pi/180)
	vectQz_cmplx=-q_y*sin(psi_detec*pi/180)+q_z*cos(psi_detec*pi/180)
	sizeY=D_y
	sizeZ=D_z
	cIntegralResult=Integrate1D(complexFormFactorFunction,0,D_z,2)*exp(sqrt(-1)*q_z*D_y/2*sqrt((sin(psi_detec*pi/180))^2))
	Return cIntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeY,sizeZ
	Variable/C result
	result=2*pi*(sizeY/2*sqrt(1-inZ^2/sizeZ^2))^2*bessel(sqrt(vectQx_cmplx^2+vectQy_cmplx^2)*(sizeY/2*sqrt(1-inZ^2/sizeZ^2)))*exp(-sqrt(-1)*vectQz_cmplx*inZ)
	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
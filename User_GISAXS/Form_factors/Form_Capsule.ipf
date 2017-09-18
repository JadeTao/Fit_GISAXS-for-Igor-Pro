#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// capsule {diameter D_y, height D_z}	D_z > D_y
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR sizeY,sizeZ,psi_detec
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y
	vectQz_cmplx=q_z
	sizeY=D_y
	sizeZ=D_z
	cIntegralResult=(Integrate1D(complexFormFactorFunction,0,D_y/2,2)+2*pi*(D_y/2)^2*(D_z-D_y)*bessel(sqrt(q_x^2+q_y^2)*D_y/2)*sinc(q_z*(D_z-D_y)/2))*exp(sqrt(-1)*q_z*D_z/2)
	Return cIntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeY,sizeZ
	Variable/C result
	result=4*pi*((sizeY/2)^2-inZ^2)*bessel(sqrt(vectQx_cmplx^2+vectQy_cmplx^2)*sqrt((sizeY/2)^2-inZ^2))*cos(vectQz_cmplx*(inZ+sizeZ/2-sizeY/2))
	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
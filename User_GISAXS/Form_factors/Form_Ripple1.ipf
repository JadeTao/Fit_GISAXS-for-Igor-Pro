#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// ripple (symmetric sinusoidal profile)
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	NVAR sizeX,sizeY,sizeZ
	Wave/D coef 
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y
	vectQz_cmplx=q_z
	sizeX=coef[14]
	sizeY=D_y
	sizeZ=D_z
	cIntegralResult=Integrate1D(complexFormFactorFunction,0,D_z,2)
	Return cIntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeX,sizeY,sizeZ
	Variable/C result
	Wave/D coef
	result=sizeX*sinc(vectQx_cmplx*sizeX/2)*sizeY/pi*acos(2*inZ/sizeZ-1)*sinc(vectQy_cmplx*sizeY/2/pi*acos(2*inZ/sizeZ-1))*exp(-sqrt(-1)*vectQz_cmplx*inZ)
	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
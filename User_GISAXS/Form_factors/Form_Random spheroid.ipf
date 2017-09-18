#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// spheroids randomly oriented {diameter D_y, height D_z}
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	NVAR sizeX,sizeY,sizeZ,psi_detec,phi_detec
	Wave/D coef
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y
	vectQz_cmplx=q_z
	sizeX=D_y
	sizeY=D_y
	sizeZ=D_z
	cIntegralResult=Integrate1D(complexFormFactorFunction,0,pi,2)/pi
	Return cIntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeX,sizeY,sizeZ
	Variable/C kk=sqrt((sqrt(vectQx_cmplx^2+(vectQy_cmplx*cos(inZ)+vectQz_cmplx*sin(inZ))^2)*sizeY/2)^2+((-vectQy_cmplx*sin(inZ)+vectQz_cmplx*cos(inZ))*sizeZ/2)^2)
	Variable/C result=(pi/6*sizeY^2*sizeZ)*3*(sin(kk)-(kk)*cos(kk))/(kk)^3

	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

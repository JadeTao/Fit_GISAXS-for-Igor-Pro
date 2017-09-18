#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C Form_factor(q_x,q_y,q_z,D_y,D_z)	// Core-shell ripple (asymmetric sawtooth profile)
	Variable/C q_x,q_y,q_z
	Variable D_y,D_z 
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx,cIntegralResult
	NVAR sizeX,sizeY,sizeZ,deltaLAY,betaLAY,deltaNPs,betaNPs,deltaNPc,betaNPc
	Wave/D coef
	Variable/C formfactorcmplx
	Variable/C tau=((1-deltaNPc-sqrt(-1)*betaNPc)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)/((1-deltaNPs-sqrt(-1)*betaNPs)^2-(1-deltaLAY-sqrt(-1)*betaLAY)^2)
	vectQx_cmplx=q_x
	vectQy_cmplx=q_y
	vectQz_cmplx=q_z
	
	sizeX=coef[14]//*D_y
	sizeY=D_y
	sizeZ=D_z
	cIntegralResult=Integrate1D(complexFormFactorFunction,0,D_z,2)

	formfactorcmplx=(1-tau)*cIntegralResult

	cIntegralResult=Integrate1D(complexFormFactorFunction,0,D_z,2)*exp(sqrt(-1)*q_z*coef[8])
	formfactorcmplx+=tau*(cIntegralResult+sizeX*sizeY*coef[8]*sinc(q_x*sizeX/2)*sinc(q_y*sizeY/2)*sinc(q_z*coef[8]/2)*exp(sqrt(-1)*q_z*coef[8]/2))

	Return formfactorcmplx
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C ComplexFormFactorFunction(inZ)
	Variable inZ
	NVAR/C vectQx_cmplx,vectQy_cmplx,vectQz_cmplx
	NVAR sizeX,sizeY,sizeZ
	Variable/C result
	Wave/D coef

	Variable anisotropy=coef[15]
	result=sizeX*sinc(vectQx_cmplx*sizeX/2)*sizeY*(1-inZ/sizeZ)*sinc(vectQy_cmplx*sizeY/2*(1-inZ/sizeZ))*exp(-sqrt(-1)*vectQy_cmplx*anisotropy*sizeY/2*(1-inZ/sizeZ))*exp(-sqrt(-1)*vectQz_cmplx*inZ)

	Return result
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

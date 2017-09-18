#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Fit_GISAXS(q_x,q_y,q_z)		// Local Monodisperse Approximation (LMA)
	Variable q_x,q_y,q_z
	Wave/D coef
	NVAR vectQx,vectQy,vectQz
	NVAR IntegralResult,Dmin,Dmax
	vectQx=q_x
	vectQy=q_y
	vectQz=q_z
	IntegralResult=Integrate1D(LMAFunction,Dmin,Dmax)
	Return abs(coef[0])+abs(coef[1])*IntegralResult
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function LMAFunction(inX)
	Variable inX
	Wave/D coef
	NVAR vectQx,vectQy,vectQz
	Variable resultLMA
	resultLMA=Size_dist(coef,inX)*Form_factor2(vectQx,vectQy,vectQz,inX,inX*Shape_dist(coef,inX))*Structure_factor(vectQx,vectQy,vectQz,inX*coef[4],inX*Shape_dist(coef,inX)*coef[4],coef[5])
	Return resultLMA
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
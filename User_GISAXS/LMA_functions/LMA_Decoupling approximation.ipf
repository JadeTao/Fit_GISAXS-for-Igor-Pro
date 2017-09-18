#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Fit_GISAXS(q_x,q_y,q_z)
	Variable q_x,q_y,q_z
	Wave/D coef
	NVAR vectQx,vectQy,vectQz
	NVAR IntegralResult,Dmin,Dmax
	Variable resultDA
	vectQx=q_x
	vectQy=q_y
	vectQz=q_z

	IntegralResult=Integrate1D(DAFunction1,Dmin,Dmax)
	resultDA=IntegralResult

	IntegralResult=magsqr(Integrate1D(DAFunction2,Dmin,Dmax))
	resultDA+=IntegralResult*(Structure_factor(q_x,q_y,q_z,coef[2]*coef[4],coef[2]*Shape_dist(coef,coef[2])*coef[4],coef[5])-1)
	Return abs(coef[0])+abs(coef[1])*resultDA
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function DAFunction1(inX)		// <|F(q)|²>
	Variable inX
	Wave/D coef
	NVAR vectQx,vectQy,vectQz
	Variable resultDA1
	resultDA1=Size_dist(coef,inX)*Form_factor2(vectQx,vectQy,vectQz,inX,inX*Shape_dist(coef,inX))
	Return resultDA1
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function/C DAFunction2(inX)	// <F(q)>
	Variable inX
	NVAR vectQx,vectQy,vectQz,sizeY,sizeZ
	Variable/C resultDA2
	resultDA2=Size_dist(coef,inX)*Form_factor_amplitude(vectQx,vectQy,vectQz,inX,inX*Shape_dist(coef,inX))
	Return resultDA2
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------


















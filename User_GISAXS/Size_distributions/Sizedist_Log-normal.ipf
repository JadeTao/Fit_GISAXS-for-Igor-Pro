#pragma rtGlobals=1		// Use modern global access method.

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Function Size_dist(w,D) : FitFunc	// Log-normal
	Wave/D w
	Variable D

	Variable fwhm=w[3]
	Variable dmean=w[2]//w[6]
	
//	Return 1/D/((1/sqrt(2*ln(2))*asinh(fwhm/2/w[2]))*sqrt(pi*2))*exp(-1/2*((ln(D)-ln(w[2]))^2)/(1/sqrt(2*ln(2))*asinh(fwhm/2/w[2]))^2)
	Return 1/D/((1/sqrt(2*ln(2))*asinh(fwhm/2/dmean))*sqrt(pi*2))*exp(-1/2*((ln(D)-ln(dmean))^2)/(1/sqrt(2*ln(2))*asinh(fwhm/2/dmean))^2)
End

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

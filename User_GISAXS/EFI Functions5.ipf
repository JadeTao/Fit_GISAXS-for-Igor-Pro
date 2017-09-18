#pragma rtGlobals=1		// Use modern global access method.

//----------------------------------------------------------------------------------------------------------------------------------

Function/C calcul_matrix(scatangle,firstinterface,lastinterface,i,j)
	Variable scatangle,firstinterface,lastinterface,i,j
	NVAR long_onde
	Wave/D delta,betta,thickness,roughness
	Variable/C m11i,m12i,m21i,m22i,m11f,m12f,m21f,m22f,kzi,kzf,r11,r12,t11,t22
	m11i=1
	m12i=0
	m21i=0
	m22i=1
	If (firstinterface==0)
		kzi=-2*pi/long_onde*sqrt((1)^2-(cos(scatangle*pi/180))^2)
	Else
		kzi=-2*pi/long_onde*sqrt((1-delta[firstinterface-1]-sqrt(-1)*betta[firstinterface-1])^2-(cos(scatangle*pi/180))^2)
	Endif

	Variable k
	For(k=firstinterface;k<lastinterface;k+=1)
		kzf=-2*pi/long_onde*sqrt((1-delta[k]-sqrt(-1)*betta[k])^2-(cos(scatangle*pi/180))^2)
		r11=(kzi+kzf)/(2*kzi)
		r12=(kzi-kzf)/(2*kzi)*exp(-2*kzi*kzf*roughness[k]^2)
		t11=exp(sqrt(-1)*kzf*thickness[k])
		t22=exp(-sqrt(-1)*kzf*thickness[k])
		
		m11f=t11*(m11i*r11+m12i*r12)
		m12f=t22*(m11i*r12+m12i*r11)
		m21f=t11*(m21i*r11+m22i*r12)
		m22f=t22*(m21i*r12+m22i*r11)

		kzi=kzf
		m11i=m11f
		m12i=m12f
		m21i=m21f
		m22i=m22f
	Endfor

	kzf=-2*pi/long_onde*sqrt((1-delta[lastinterface]-sqrt(-1)*betta[lastinterface])^2-(cos(scatangle*pi/180))^2)
	r11=(kzi+kzf)/(2*kzi)
	r12=(kzi-kzf)/(2*kzi)*exp(-2*kzi*kzf*roughness[lastinterface]^2)

	m11f=m11i*r11+m12i*r12
	m12f=m11i*r12+m12i*r11
	m21f=m21i*r11+m22i*r12
	m22f=m21i*r12+m22i*r11
	
	Return -(i-2)*(-(j-2)*m11f+(j-1)*m12f)+(i-1)*(-(j-2)*m21f+(j-1)*m22f)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function/C calcul_matrix_RTRT(scatangle,firstinterface,lastinterface,i,j)
	Variable scatangle,firstinterface,lastinterface,i,j
	NVAR long_onde
	Wave/D delta,betta,thickness,roughness
	Variable/C m11i,m12i,m21i,m22i,m11f,m12f,m21f,m22f,kzi,kzf,r11,r12,t11,t22
	m11i=1
	m12i=0
	m21i=0
	m22i=1
	If (firstinterface==0)
		kzi=-2*pi/long_onde*sqrt((1)^2-(cos(scatangle*pi/180))^2)
	Else
		kzi=-2*pi/long_onde*sqrt((1-delta[firstinterface-1]-sqrt(-1)*betta[firstinterface-1])^2-(cos(scatangle*pi/180))^2)
	Endif

	Variable k
	For(k=firstinterface;k<lastinterface;k+=1)
		kzf=-2*pi/long_onde*sqrt((1-delta[k]-sqrt(-1)*betta[k])^2-(cos(scatangle*pi/180))^2)
		r11=(kzi+kzf)/(2*kzi)
		r12=(kzi-kzf)/(2*kzi)*exp(-2*kzi*kzf*roughness[k]^2)
		t11=exp(sqrt(-1)*kzf*thickness[k])
		t22=exp(-sqrt(-1)*kzf*thickness[k])
		
		m11f=t11*(m11i*r11+m12i*r12)
		m12f=t22*(m11i*r12+m12i*r11)
		m21f=t11*(m21i*r11+m22i*r12)
		m22f=t22*(m21i*r12+m22i*r11)

		kzi=kzf
		m11i=m11f
		m12i=m12f
		m21i=m21f
		m22i=m22f
	Endfor

		m11f=m11i
		m12f=m12i
		m21f=m21i
		m22f=m22i

	Return -(i-2)*(-(j-2)*m11f+(j-1)*m12f)+(i-1)*(-(j-2)*m21f+(j-1)*m22f)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function/C calcul_matrix_TRTR(scatangle,firstinterface,lastinterface,i,j)
	Variable scatangle,firstinterface,lastinterface,i,j
	NVAR long_onde
	Wave/D delta,betta,thickness,roughness
	Variable/C m11i,m12i,m21i,m22i,m11f,m12f,m21f,m22f,kzi,kzf,r11,r12,t11,t22
	m11i=1
	m12i=0
	m21i=0
	m22i=1
	kzi=-2*pi/long_onde*sqrt((1-delta[firstinterface]-sqrt(-1)*betta[firstinterface])^2-(cos(scatangle*pi/180))^2)

	Variable k
	For(k=firstinterface;k<lastinterface;k+=1)
		kzf=-2*pi/long_onde*sqrt((1-delta[k+1]-sqrt(-1)*betta[k+1])^2-(cos(scatangle*pi/180))^2)
		r11=(kzi+kzf)/(2*kzi)
		r12=(kzi-kzf)/(2*kzi)*exp(-2*kzi*kzf*roughness[k]^2)
		t11=exp(sqrt(-1)*kzi*thickness[k])
		t22=exp(-sqrt(-1)*kzi*thickness[k])
		
		m11f=t11*(m11i*r11+m21i*r12)
		m12f=t11*(m12i*r11+m22i*r12)
		m21f=t22*(m11i*r12+m21i*r11)
		m22f=t22*(m12i*r12+m22i*r11)

		kzi=kzf
		m11i=m11f
		m12i=m12f
		m21i=m21f
		m22i=m22f
	Endfor

		m11f=m11i
		m12f=m12i
		m21f=m21i
		m22f=m22i

	Return -(i-2)*(-(j-2)*m11f+(j-1)*m12f)+(i-1)*(-(j-2)*m21f+(j-1)*m22f)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function/C champincidentmoins(angl)		// U- (up)
	Variable angl
	Variable nlayer=numpnts(delta)-1
	Variable/G slayer
	
	Return calcul_matrix(angl,slayer,nlayer,2,2)/calcul_matrix(angl,0,nlayer,2,2)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function/C champincidentplus(angl)		//	U+ (up)
	Variable angl
	Variable nlayer=numpnts(delta)-1
	Variable/G slayer
	
	Return calcul_matrix(angl,slayer,nlayer,1,2)/calcul_matrix(angl,0,nlayer,2,2)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function/C champincidentmoinsdown(angl)		// V- (down)
	Variable angl
	Variable nlayer=numpnts(delta)-1
	Variable/G slayer
	
	Return calcul_matrix_TRTR(angl,slayer,nlayer,2,2)/calcul_matrix(angl,0,nlayer,2,2)
End

//----------------------------------------------------------------------------------------------------------------------------------

Function/C champincidentplusdown(angl)		//	V+ (down)
	Variable angl
	Variable nlayer=numpnts(delta)-1
	Variable/G slayer
	
	Return calcul_matrix_TRTR(angl,slayer,nlayer,1,2)/calcul_matrix(angl,0,nlayer,2,2)
End

//----------------------------------------------------------------------------------------------------------------------------------


Function calc_efi(angl,interface)
	Variable angl,interface
	NVAR slayer
	
	slayer=interface

	Return magsqr(champincidentmoins(angl)+champincidentplus(angl))
End

//----------------------------------------------------------------------------------------------------------------------------------

Function calc_efi2z(angl,depth)
	Variable angl,depth
	NVAR slayer
	Variable s_layer=slayer
	Variable i=-1
	Variable j=0
	Wave/D delta, betta, thickness, roughness
	
	Duplicate/O/D delta deltatemp1
	Duplicate/O/D betta bettatemp1
	Duplicate/O/D thickness thicknesstemp1
	Duplicate/O/D roughness roughnesstemp1

//	depth=max(1e-15,depth)
	Do
		i+=1
		j+=thickness[i]
	While (depth>j)

	InsertPoints i,1, delta,betta,thickness,roughness
	delta[i]=delta[i+1]
	betta[i]=betta[i+1]
	thickness[i]=depth-sum(thickness,0,i-1)
	thickness[i+1]=j-depth
	roughness[i]=roughness[i+1]
	roughness[i+1]=0

	slayer=i+1

	Variable efitemp=magsqr(champincidentmoins(angl)+champincidentplus(angl))

	Duplicate/O/D deltatemp1 delta
	Duplicate/O/D bettatemp1 betta
	Duplicate/O/D thicknesstemp1 thickness
	Duplicate/O/D roughnesstemp1 roughness
	Killwaves deltatemp1,bettatemp1,thicknesstemp1,roughnesstemp1
	slayer=s_layer
	
	Return efitemp
End

//----------------------------------------------------------------------------------------------------------------------------------


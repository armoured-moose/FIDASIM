FUNCTION d3d_beams,inputs

	;; Here are the TRANSP numbers
	;; This places the aperture as actually located, and the source is
	;; then "xedge" cm further away from the vessel.
	;;     30LT     30RT 150LT 150RT 210LT     210RT     330LT 330RT
	us_NB=[430.24933, 393.89442, $
	       180.16372, 235.25667, $
	       -235.25671, -180.16376, $
	       -180.16373, -235.25668]
	vs_NB=[456.44009, 499.06619,$
	       -600.82700, -590.65572,$
	       -590.65570, -600.82699,$
	       600.82700, 590.65572]


	; Cross-over points [30,30,150,150,210,210,330,330] measured by CER group
	u_co=[129.2599,129.2599, 142.2877, 142.2877, -141.09, -141.09,-139.4861,-139.4861]
	v_co=[239.3489,239.3489,-232.1300,-232.1300, -230.40, -230.40, 233.7739, 233.7739]

	;; 30LT is closer to the beamers' description, not original CER Grierson.
	u_co[0]=132.334 & u_co[1]=u_co[0]
	v_co[0]=238.76 & v_co[1]=v_co[0]
	nsources=n_elements(vs_NB)
	xyz_src=[[double(us_NB)],[double(vs_NB)],[replicate(0.0d,nsources)]]
	xyz_pos=[[double(u_co)],[double(v_co)],[replicate(0.0d,nsources)]]

	focy=replicate(1d33,nsources)      ; horizontal focal length (infinity)
	focz=replicate(1000d0,nsources)      ; vertical focal length is 10 m
	divy=replicate(8.73d-3,3,nsources)    ; horizontal divergence in radians
	divz=replicate(2.27d-2,3,nsources)

	bmwidra=6d0     ; ion source half width in cm
	bmwidza=24d0    ; ion source half height in cm
 

	;;Get beam energy,power and fractions
	beam_num=indgen(nsources)
	einj=get_beam_volts(inputs.shot,inputs.time*1000,beam_num)
	pinj=get_beam_powers(inputs.shot,inputs.time*1000,beam_num)*10.0d^(-3.0d) ;;convert from kW to MW
	einj=double(einj) & pinj=double(pinj)
    ;;GET SPECIES_MIX
    cgfitf=[-0.109171,0.0144685,-7.83224e-5]
    cgfith=[0.0841037,0.00255160,-7.42683e-8]
    ;; Current fractions
    ffracs=cgfitf[0]+cgfitf[1]*einj+cgfitf[2]*einj^2
    hfracs=cgfith[0]+cgfith[1]*einj+cgfith[2]*einj^2
    tfracs=1.0-ffracs-hfracs
	

	;;SAVE IN NBI STRUCTURE
	nbi={einj:einj,pinj:pinj,full:ffracs,half:hfracs,third:tfracs,$
		 xyz_src:xyz_src,xyz_pos:xyz_pos,bmwidra:bmwidra,bmwidza:bmwidza,$
		 divy:divy,divz:divz,focy:focy,focz:focz}
	return,nbi
END

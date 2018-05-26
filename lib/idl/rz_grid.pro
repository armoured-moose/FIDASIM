FUNCTION rz_grid,rmin,rmax,nr,zmin,zmax,nz,phimin=phimin,phimax=phimax,nphi=nphi
    ;+#rz_grid
    ;+Creates interpolation grid
    ;+***
    ;+##Arguments
    ;+    **rmin**: Minimum radius [cm]
    ;+
    ;+    **rmax**: Maximum radius [cm]
    ;+
    ;+    **nr**: Number of radii
    ;+
    ;+    **zmin**: Minimum Z value [cm]
    ;+
    ;+    **zmax**: Maximum Z value [cm]
    ;+
    ;+    **nz**: Number of z values
    ;+
    ;+##Return Value
    ;+Interpolation grid structure
    ;+
    ;+##Example Usage
    ;+```idl
    ;+IDL> grid = rz_grid(0,200.0,200,-100,100,200)
    ;+```

;;; Are the units right on this?
    if not keyword_set(phimin) then phimin = 0.0 ;rad
    if not keyword_set(phimax) then phimax = 0.01 ;rad
    if not keyword_set(nphi) then nphi = 1

    dr = (rmax-rmin)/(nr-1)
;;; Might need to put an if statement here for when there are a lot of dphi values 
;;; I also feel that dphi = 0 when nphi = 1
    dphi = (phimax-phimin)/nphi
;;; End
    dz = (zmax-zmin)/(nz-1)
    r = rmin + dr*dindgen(nr)
;;; From this, there should only be one phi value, 0
    phi = phimin + dphi*dindgen(nphi)
;;; End
    z = zmin + dz*dindgen(nz)

;;; Do I need to change this?
    r2d = r # replicate(1,nz)
    z2d = replicate(1,nr) # z


    grid = {r2d:r2d,z2d:z2d,r:r,z:z,phi:phi,nr:nr,nz:nz,nphi:nphi}
    
    return, grid
END

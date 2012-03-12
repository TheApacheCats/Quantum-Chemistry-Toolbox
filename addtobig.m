function Vout = addtobig(Vbig, Vin, v0 , dv)
Vout = Vbig;
Ny = size(Vin,1);
Nx = size(Vin,2);
Nz = size(Vin,3);
Nzmax = size(Vbig,3);
Nxmax = size(Vbig,2);
Nymax = size(Vbig,1);

if(nargin == 3)
    x0 = v0(1);
    y0 = v0(2);
    z0 = v0(3);
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                if(k+z0 <= Nzmax && j+y0 <= Nymax && i+x0 <= Nxmax)
                    if(k+z0 > 1 && j+y0 > 1 && i+x0 > 1)
                        Vout(j+y0,i+x0,k+z0) = Vbig(j+y0,i+x0,k+z0) + Vin(j,i,k);
                    end
                end
            end
        end
    end
elseif (nargin == 4)
    x = 0:(Nx - 1);
    y = 0:(Ny - 1);
    z = 0:(Nz - 1);
    x = x*dv(1);
    y = y*dv(2);
    z = z*dv(3);
    [X Y Z] = meshgrid(x, y, z);
    vactual = round(v0./dv).*dv;
    vdiff = v0 - vactual;
    [XI YI ZI] = meshgrid(x - vdiff(1), y - vdiff(2), z - vdiff(3));
    Vinterp = interp3(X, Y, Z, Vin, XI, YI, ZI,'linear',0);
    vshift = round(v0./dv);
    x0 = vshift(1);
    y0 = vshift(2);
    z0 = vshift(3);
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                if(k+z0 <= Nzmax && j+y0 <= Nymax && i+x0 <= Nxmax)
                    if(k+z0 > 1 && j+y0 > 1 && i+x0 > 1)
                        Vout(j+y0,i+x0,k+z0) = Vbig(j+y0,i+x0,k+z0) + Vinterp(j,i,k);
                    end
                end
            end
        end
    end
end
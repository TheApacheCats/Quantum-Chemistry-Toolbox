function cube = qcMolecule2Cube(molecule, X, Y, Z, norbital)
% cube = qcMolecule2Cube(molecule, X, Y, Z, norbital)
% generate a cubefile from molecule orbital coefficents stored in a molecule
% structure

Nx = size(X,2);
Ny = size(X,1);
Nz = size(X,3);

% molecular orbital coefficients
MO_coeff = molecule.MO_coeff(:,norbital);
psi = zeros(Ny, Nx, Nz);
ci = 0;
for ni = 1:length(molecule.basis_type)
    type = molecule.basis_type{ni}; % S, SP orbital
    vp0 = molecule.position(molecule.basis_num{ni},:); % position of atom
    Rsq = (X-vp0(1)).^2 + (Y-vp0(2)).^2 + (Z-vp0(3)).^2; % R.^2
    %R = sqrt((X-vp0(1)).^2 + (Y-vp0(2)).^2 + (Z-vp0(3)).^2); 
    cgtf_coeff = molecule.basis_coeff{ni};

    if strcmp(type,'S') % S orbital
        ci = ci + 1;
        temp = zeros(Ny, Nx, Nz);
        for nj = 1:size(cgtf_coeff,1) % assemble contracted gaussian
            alpha = cgtf_coeff(nj,1);
            normalization_constant = (2*alpha/pi)^(3/4);
           temp = temp + MO_coeff(ci)*normalization_constant*cgtf_coeff(nj,2).*exp(-alpha*Rsq) ;
        end
    end
    if strcmp(type,'SP') % SP orbital
        ci = ci + 1; % S
        temp = zeros(Ny, Nx, Nz);
        for nj = 1:size(cgtf_coeff,1) % assemble contracted gaussian
            alpha = cgtf_coeff(nj,1);
            normalization_constant = (2*alpha/pi)^(3/4);
            temp = temp + MO_coeff(ci)*normalization_constant*cgtf_coeff(nj,2).*exp(-alpha*Rsq) ;
        end
        ci = ci + 1; % PX
        for nj = 1:size(cgtf_coeff,1) % assemble contracted gaussian
            alpha = cgtf_coeff(nj,1);
            normalization_constant = (2*alpha/pi)^(3/4)*sqrt(8*alpha/2);
            temp = temp + MO_coeff(ci)*normalization_constant*(X-vp0(1)).*cgtf_coeff(nj,3).*exp(-alpha*Rsq) ;
        end
        ci = ci + 1; % PY
        for nj = 1:size(cgtf_coeff,1) % assemble contracted gaussian
            alpha = cgtf_coeff(nj,1);
            normalization_constant = (2*alpha/pi)^(3/4)*sqrt(8*alpha/2);
            temp = temp + MO_coeff(ci)*normalization_constant*(Y-vp0(2)).*cgtf_coeff(nj,3).*exp(-alpha*Rsq) ;
        end
        ci = ci + 1; % PZ
        for nj = 1:size(cgtf_coeff,1) % assemble contracted gaussian
            alpha = cgtf_coeff(nj,1);
            normalization_constant = (2*alpha/pi)^(3/4)*sqrt(8*alpha/2);
            temp = temp + MO_coeff(ci)*normalization_constant*(Z-vp0(3)).*cgtf_coeff(nj,3).*exp(-alpha*Rsq) ;
        end
    end
    psi = psi + temp;
end
cube.psi = psi;

function c = qcAtomicColor(AN)
% c = qcAtomicColor(AN)
%
% c, color of atom
% AN, atomic number

switch(AN)
    case 1 % hydrogen
        c = [1 1 1]*0.9;
    case 6 % carbon
        c = [0 0 0];
    case 8 % oxygen
        c = [0.8 0 0];
    case 29 % copper
        c = [255 176 40]/255;
    case 77 % iridium
        c = [198 56 255]/255;
    otherwise
        c = [0.1 0.1 0.1];
end
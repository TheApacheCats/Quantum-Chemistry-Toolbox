function [basis_type basis_coeff basis_num number_of_basis_functions] = parselink301
% reads in basis used by calculation

files = dir('301-*.txt');
filename = files(1).name;
fid = fopen(filename);
inbasis_set = 0;
newatom = 0;
molecule = [];
natoms = 0;
while feof(fid) == 0
    tline = fgetl(fid);
    if strfind(tline,'There are')
        inbasis_set = 0;
    end
    if inbasis_set && newatom
        newatom = 0;
        natoms = natoms + 1;
    end
    if inbasis_set && isorbitaltop(tline)
        d = getCGTF(fid,tline);
        d.number = natoms;
        molecule = [molecule d];
    end
    if strfind(tline,'****')
        newatom = 1;
    end
    if strfind(tline,'AO basis set')
        inbasis_set = 1;
        newatom = 1;
    end
    if strfind(tline,'basis functions,');
        number_of_basis_functions = str2num(tline(1:7));
    end
end
fclose(fid);
basis_type = {molecule.type};
basis_coeff = {molecule.coeff};
basis_num = {molecule.number};

%--------------------------------------------------------------------------
function [a type]= isorbitaltop(tline)
buf = '';
if length(tline) >= 3
    buf = tline(1:3);
    type = strtrim(buf);
end
isorbital = 0;
if strfind(buf,'S')
    isorbital = 1;
end
if strfind(buf,'SP')
    isorbital = 1;
end
if strfind(buf,'D')
    isorbital = 1;
end
a = isorbital;

function cgtf = getCGTF(fid, tline)
d = [];

[isorbital type] = isorbitaltop(tline);
if isorbital
    c = str2num(tline(4:end));
    d = [];
    for ni = 1:c(1)
        tline = fgetl(fid);
        d = [d; str2num(tline)];
    end
end
cgtf.type = type;
cgtf.coeff = d;
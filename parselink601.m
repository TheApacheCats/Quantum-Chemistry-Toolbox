function [MO_type MO_energy MO_coeff MO_atom] = parselink601(filename)
% gets the coeffeicients for the molecular orbitals

if nargin == 0
    files = dir('601*.txt');
    filename = files(end).name;
end
fid = fopen(filename);
[basis_type basis_coeff basis_num number_of_basis_functions] = parselink301;
while feof(fid) == 0
    tline = fgetl(fid);
    buf = 'The electronic state is';
    if strfind(tline,buf)
        energies = geteigen(fid);
        Norbitals = number_of_basis_functions;
        MO = [];
        for ni = 1:ceil(Norbitals/5)
            [a b c] = getmo(fid, Norbitals);           
            MO = [MO a];
        end
    end
end
fclose(fid);
MO_type = b;
MO_energy = energies;
MO_coeff = MO;
MO_atom = c; % need to implement

%--------------------------------------------------------------------------
function [MO type atom]= getmo(fid, Norbitals)
% skip first 3 lines
for ni = 1:3
    tline = fgetl(fid);
end
N = Norbitals;
MO = [];
type = [];
atom = [];
for ni = 1:N
    tline = fgetl(fid);
    atom = [atom; tline(5:6)];
    type = [type; tline(13:16)];
    tline = tline(20:end);
    tline = strrep(tline,'-',' -');
    MO = [MO; str2num(tline)];
end

%--------------------------------------------------------------------------
function energies = geteigen(fid)
buf = 'Molecular Orbital Coefficients';
isvalid = 1;
energies = [];
while isvalid
    tline = fgetl(fid);
    if strfind(tline,buf)
        isvalid = 0;
    end
    if isvalid
        tline = tline(30:end);
        energies = [energies str2num(tline)];
    end
end
energies = energies';


% extract energies

% tic
% fid = fopen('601.txt');
% fid2 = fopen('energies.txt','w');
% flag = 0;
% while feof(fid) == 0
%     tline = fgetl(fid);
%    
%     N = length(tline);
%     if N >= 38
%        if(strcmp(tline(1:35), ' Total kinetic energy from orbitals'))
%             flag = 0;
%         end
%         if(strcmp(tline(1:38), ' Orbital energies and kinetic energies'))
%             flag = 1;
%             tline = fgetl(fid);
%             tline = fgetl(fid);
%         end
%     end
%     if(flag)
%         fprintf(fid2,'%s\n',tline);
%     end
% end
% fclose(fid);
% fclose(fid2);
% toc
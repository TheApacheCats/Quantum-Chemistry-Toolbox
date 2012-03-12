function [oglfile] = qcLoadOgl(filein)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% qcLoadOgl - loads OGL file
%
% Last Updated: 7/13/2007 WM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OGL file format
% line 1: header
% line 2: molecule header
% line 3: size of molecule
% line 4: number of atoms
% lines : definition of each molecule
%       : <atomic number> <x coord> <y coord> <z coord> <number of
%       connections> <connected to atom number> <...>
% line  : surface header postive part of wavefunction
% lines : surface data consisting of normal, then vertex of triangles
% line  : surface header negative part
% lines : surface data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Variables:
% atomtype - atomic number
% atomcoord - coordinate of atom
% atomconn - connections b/w this atom and others
% surface1 - normal and vertex data alternating for triangles for + wavefn
% surface2 - normal and vertex data alternating for triangles for - wavefn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(filein);
if(fid == -1)
    disp 'File not found!';
    return
end
flag_surf1 = 0;
flag_surf2 = 0;

nsurf1 = 0;
nsurf2 = 0;

disp 'Reading OGL...'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check header
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tline = strtrim(fgetl(fid));
if ~strcmp(tline,'[MOLDENOGL]')
    disp 'Not OGL Format!'
    beep
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get molecule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tline = strtrim(fgetl(fid));
[tline rem] = strtok(tline);
if ~strcmp(tline,'[MOLECULE]')
    disp 'error'
    beep
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tline = strtrim(fgetl(fid));
[num1 rem] = strtok(tline);
[num2 rem] = strtok(rem);
[num3 rem] = strtok(rem);
Lx = str2num(num1);
Ly = str2num(num2);
Lz = str2num(num3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get number of atoms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tline = strtrim(fgetl(fid));
Natoms = str2num(tline);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% list atoms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
atomtype = zeros(1,Natoms);
atomcoord = zeros(Natoms,3);
for i = 1:Natoms
    % get atom type
    tline = strtrim(fgetl(fid));    
    [buf rem] = strtok(tline);
    atomtype(i) = str2num(buf);
    % get coordinates of atom
    [buf rem] = strtok(rem);
    atomcoord(i,1) = str2num(buf);
    [buf rem] = strtok(rem);
    atomcoord(i,2) = str2num(buf);
    [buf rem] = strtok(rem);
    atomcoord(i,3) = str2num(buf);
    % get number of connections
    [buf rem] = strtok(rem);
    j = 0;
    % get connections
    while(rem)
        [buf rem] = strtok(rem);
        j = j + 1;
        atomconn(i,j) = str2num(buf);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read surface information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while feof(fid) == 0
    tline = strtrim(fgetl(fid));
    if flag_surf1 && ~flag_surf2 &&  strcmp('[SURFACE]',tline)
        disp '2nd surface'
        flag_surf2 = 1;
    elseif ~flag_surf1 && strcmp('[SURFACE]',tline)
        disp '1st surface'
        flag_surf1 = 1;
    elseif flag_surf1
        [num1 rem] = strtok(tline);
        [num2 rem] = strtok(rem);
        [num3 rem] = strtok(rem);
        if flag_surf2
            nsurf2 = nsurf2 + 1 ;
            surface2(nsurf2, 1) = str2num(num1);
            surface2(nsurf2, 2) = str2num(num2);
            surface2(nsurf2, 3) = str2num(num3);
        elseif flag_surf1
            nsurf1 = nsurf1 +1 ;
            surface1(nsurf1, 1) = str2num(num1);
            surface1(nsurf1, 2) = str2num(num2);
            surface1(nsurf1, 3) = str2num(num3);
        end
        
    end
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oglfile.AtomicNum = atomtype;
oglfile.AtomCoord = atomcoord;
oglfile.AtomConn = atomconn;
oglfile.surface1 = surface1;
oglfile.surface2 = surface2;


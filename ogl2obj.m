filein = 'molden.ogl';
fileout = 'test.obj';

% function [atomtype, atomcoord, atomconn] = obj2obj(filein, fileout)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ogl2obj.m - converts OGL file format from molden visualizer into OBJ 3d
% graphics file format
%
% Last Updated: 6/22/2007 WM
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

disp 'Reading OGL...'
fid = fopen(filein);
flag_surf1 = 0;
flag_surf2 = 0;

nsurf1 = 0;
nsurf2 = 0;

% check header
tline = strtrim(fgetl(fid));
if ~strcmp(tline,'[MOLDENOGL]')
    disp 'error'
    return
end

% get molecule
tline = strtrim(fgetl(fid));
[tline rem] = strtok(tline);
if ~strcmp(tline,'[MOLECULE]')
    disp 'error'
    return
end

% get size
tline = strtrim(fgetl(fid));
[num1 rem] = strtok(tline);
[num2 rem] = strtok(rem);
[num3 rem] = strtok(rem);
Lx = str2num(num1);
Ly = str2num(num2);
Lz = str2num(num3);

% get number of atoms
tline = strtrim(fgetl(fid));
Natoms = str2num(tline);

% list atoms
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

% read surface information
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
% Write surfaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp 'Writing OBJ...'
fout = fopen(fileout, 'w');

% verticies
disp 'verts...'
for i = 1:nsurf1/2
    fprintf(fout, 'v %f %f %f\n', surface1(2*i,1), surface1(2*i,2), surface1(2*i,3));
end
for i = 1:nsurf2/2
    fprintf(fout, 'v %f %f %f\n', surface2(2*i,1), surface2(2*i,2), surface2(2*i,3));
end
% normals
for i = 1:nsurf1/2
    fprintf(fout, 'vn %f %f %f\n', surface1(2*i-1, 1), surface1(2*i-1, 2), surface1(2*i-1, 3));
end
for i = 1:nsurf2/2
    fprintf(fout, 'vn %f %f %f\n', surface2(2*i-1, 1), surface2(2*i-1, 2), surface2(2*i-1, 3));
end

% faces
disp 'faces...'
fprintf(fout,'g surface1\n');

for i = 1:(nsurf1)/6
    fprintf(fout, 'f %i//%i %i//%i %i//%i\n', ...
    3*i-2, 3*i-2, ...
    3*i-1, 3*i-1, ...
    3*i, 3*i);
end

fprintf(fout,'g surface2\n');

for j = 1:nsurf2/6
    i = j + nsurf1/6;
    fprintf(fout, 'f %i//%i %i//%i %i//%i\n', ...
    3*i-2, 3*i-2, ...
    3*i-1, 3*i-1, ...
    3*i, 3*i);
end

fclose(fout);

plotmolecule(atomtype, atomcoord, atomconn);
plotwavefn(surface1, surface2);

disp 'Done'
beep
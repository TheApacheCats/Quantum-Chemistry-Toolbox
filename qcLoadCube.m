function cubefile = qcLoadCube(sFile)
% Loads Gaussian Cube files
% % http://local.wasp.uwa.edu.au/~pbourke/dataformats/cube/
% Header
%
% The first two lines of the header are comments, they are generally
% ignored by parsing packages or used as two default labels.
%
% The third line has the number of atoms included in the file followed by
% the position of the origin of the volumetric data.
%
% The next three lines give the number of voxels along each axis (x, y, z)
% followed by the axis vector. Note this means the volume need not be
% aligned with the coordinate axis, indeed it also means it may be sheared
% although most volumettric packages won't support that. The length of each
% vector is the length of the side of the voxel thus allowing non cubic
% volumes. If the sign of the number of voxels in a dimension is positive
% then the units are Angstroms, if negative then Bohr.
%
% The last section in the header is one line for each atom consisting of 5
% numbers, the first is the atom number, second (?), the last three are the
% x,y,z coordinates of the atom center. Volumetric data The volumetric data
% is straightforward, one floating point number for each volumetric
% element. The original Gaussian format arranged the values in the format
% shown below in the example, most parsing programs can read any white
% space separated format. Traditionally the grid is arranged with the x
% axis as the outer loop and the z axis as the inner loop, for example,
% written as
%
%    for (ix=0;ix<NX;ix++) {
%       for (iy=0;iy<NY;iy++) {
%          for (iz=0;iz<NZ;iz++) {
%             printf("%g ",data[ix][iy][iz]);
%             if (iz % 6 == 5)
%                printf("\n");
%          }
%          printf("\n");
%       }
%    }

% a cubefile can be generated in two ways: molden and Gaussian utility cubegen

fid = fopen(sFile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get comments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ismolden = 0;
tline = fgetl(fid);
if(strcmp('Molden',tline(1:6)))
    ismolden = 1;
end
if(~ismolden)
%     disp('not yet equipped to handle non molden files');
end
tline = fgetl(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get number of atoms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tline = fgetl(fid);
[buf rem] = strtok(tline);
% for some reason I've had a negative number here in the output
Natoms = abs(str2num(buf)); 
% get position of origin
vOrigin = str2num(rem);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get voxel information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% e1
tline = fgetl(fid);
x = str2num(tline);
Ne1 = x(1);
ve1(1:3) = x(2:4);
% e2
tline = fgetl(fid);
x = str2num(tline);
Ne2 = x(1);
ve2(1:3) = x(2:4);
% e3
tline = fgetl(fid);
x = str2num(tline);
Ne3 = x(1);
ve3(1:3) = x(2:4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get atoms and locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NAtomicNum = zeros(1,Natoms);
AtomCoord = zeros(Natoms, 3);

for i = 1:Natoms
    tline = fgetl(fid);
    x = str2num(tline);
    NAtomicNum(i) = x(1);
    AtomCoord(i, 1:3) = x(3:5);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get rest of data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% old
% W = textscan(fid, '%f64',Ne3*Ne2*Ne1);
% W = W{1};

% new takes into account output bug where it forgets the 'E'
W = zeros(Ne3*Ne2*Ne1,1);
ci = 0;
if(~ismolden)
    tline = fgetl(fid); % extra line added by cubegen
end
while feof(fid) == 0
    tline = fgetl(fid);
    tline = textscan(tline,'%s');
%     tline{1}
    tline = tline{1};
    for ni = 1:length(tline);
        buf = tline{ni};
        if buf(end-3) ~= 'E'
            buf = [buf(1:end-4) 'E' buf(end-3:end)];
        end
        ci = ci + 1;
        W(ci) = str2double(buf);
    end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% construct data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cubefile.Natoms = Natoms;
cubefile.vOrigin = vOrigin;
cubefile.Ne1 = Ne1;
cubefile.Ne2 = Ne2;
cubefile.Ne3 = Ne3;
cubefile.ve1 = ve1;
cubefile.ve2 = ve2;
cubefile.ve3 = ve3;
cubefile.NAtomicNum = NAtomicNum;
cubefile.AtomCoord = AtomCoord;
% read matlab isosurf for details on indices
ci = 0;
for i = 1:Ne1
    for j = 1:Ne2
        for k = 1:Ne3
            ci = ci + 1;
            cubefile.V(j, i, k) = W(ci);
        end
    end
end

% test, rotate things back into axis aligned coordinates
% plotting does not work well with non axis aligned coordinates
A = [cubefile.ve1' cubefile.ve2' cubefile.ve3'];
I = [norm(cubefile.ve1) 0 0; 0 norm(cubefile.ve2) 0; 0 0 norm(cubefile.ve3)];
R = I/A;
cubefile.AtomCoord = (R*(AtomCoord-repmat(vOrigin,Natoms,1))')';
cubefile.ve1 = [norm(cubefile.ve1) 0 0];
cubefile.ve2 = [0 norm(cubefile.ve2) 0];
cubefile.ve3 = [0 0 norm(cubefile.ve3)];
cubefile.vOrigin = [0 0 0];
function record = xyzread(filename)
% reads xyz files
if nargin == 0
    filename = uigetfile('*.xyz');
end

record = [];
fid = fopen(filename);
ci = 0;
ci = ci + 1;
Natoms = str2num(fgetl(fid));
record.num_atoms = Natoms;
[a b] = strtok(fgetl(fid),':');
[a b] = strtok(b(2:end),'meV');
record.mode_energy = zeros(Natoms*3,1);
record.mode_energy(ci) = str2double(a);

vib.f = zeros(1, 3*Natoms-6);
record.AN = zeros(Natoms,1);
vib.x = zeros(Natoms, 3*Natoms-6);
vib.y = zeros(Natoms, 3*Natoms-6);
vib.z = zeros(Natoms, 3*Natoms-6);
vp = zeros(Natoms,3);
for ni = 1:Natoms
    tline = fgetl(fid);
    record.AN(ni) = getAN(tline(1:2));
    v = str2num(tline(3:end));
    vp(ni,:) = v(1:3);
    vib.x(ni,1) = v(4);
    vib.y(ni,1) = v(5);
    vib.z(ni,1) = v(6);
end
record.vp = vp;
% rest of file
while ~feof(fid)
    ci = ci + 1;
    Natoms = str2num(fgetl(fid));
    record.num_atoms = Natoms;
    [a b] = strtok(fgetl(fid),':');
    [a b] = strtok(b(2:end),'meV');
    record.mode_energy(ci) = str2double(a);    
    for ni = 1:Natoms
        tline = fgetl(fid);
        %record.AN(ni) = getAN(tline(1:2));
        v = str2num(tline(3:end));
        vp(ni,:) = v(1:3);
        vib.x(ni,ci) = v(4);
        vib.y(ni,ci) = v(5);
        vib.z(ni,ci) = v(6);
    end
    record.vp = vp;
end
record.x = vib.x;
record.y = vib.y;
record.z = vib.z;
fclose(fid);

function AN = getAN(tline)
if strcmp(tline(1:2),'Cu')
    AN = 29;
end
if strcmp(tline,' O')
    AN = 8;
end
if strcmp(tline,' C')
    AN = 6;
end

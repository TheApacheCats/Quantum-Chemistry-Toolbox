function vib = parselink716()
% extracts information on vibrational mode
files = dir('716-*.txt');
filename = files(end).name;
Natoms = parselink101();

vib.f = zeros(1, 3*Natoms-6);
vib.mu = zeros(1, 3*Natoms-6);
vib.fc = zeros(1, 3*Natoms-6);
vib.ir = zeros(1, 3*Natoms-6);
vib.AN = zeros(1, Natoms);
vib.x = zeros(Natoms, 3*Natoms-6);
vib.y = zeros(Natoms, 3*Natoms-6);
vib.z = zeros(Natoms, 3*Natoms-6);
vib.mag = zeros(Natoms, 3*Natoms-6);

fid = fopen(filename);
tline = fgetl(fid);
while tline(end) ~= ':' && feof(fid) == 0
    tline = fgetl(fid);
end
tline = fgetl(fid);
while isempty(strfind(tline,'normal coordinates:')) && feof(fid) == 0
    tline = fgetl(fid);
end

vibinrow = 0;
j = 0;
while feof(fid) == 0
    % get frequency number
    tline = fgetl(fid);
    vibinrow = length(string2num(tline));

    % check to see if we have reached end of frequencies
    if(length(tline) == 0)
        fclose(fid);        
        return
    end
    tline = fgetl(fid);
    % freq
    tline = fgetl(fid);
    [buf rem] = strtok(tline);
    [buf rem] = strtok(rem);
    [f1 rem] = strtok(rem);
    [f2 rem] = strtok(rem);
    [f3 rem] = strtok(rem);
    vib.f(3*j + 1) = str2num(f1);
    vib.f(3*j + 2) = str2num(f2);
    vib.f(3*j + 3) = str2num(f3);
    % mass
    tline = fgetl(fid);
    [buf rem] = strtok(tline);
    [buf rem] = strtok(rem);
    [buf rem] = strtok(rem);
    [f1 rem] = strtok(rem);
    [f2 rem] = strtok(rem);
    [f3 rem] = strtok(rem);
    vib.mu(3*j + 1) = str2num(f1);
    vib.mu(3*j + 2) = str2num(f2);
    vib.mu(3*j + 3) = str2num(f3);
     % fc
    tline = fgetl(fid);
    [buf rem] = strtok(tline);
    [buf rem] = strtok(rem);
    [buf rem] = strtok(rem);
    [f1 rem] = strtok(rem);
    [f2 rem] = strtok(rem);
    [f3 rem] = strtok(rem);
    vib.fc(3*j + 1) = str2num(f1);
    vib.fc(3*j + 2) = str2num(f2);
    vib.fc(3*j + 3) = str2num(f3);
    % ir
    tline = fgetl(fid);
    [buf rem] = strtok(tline);
    [buf rem] = strtok(rem);
    [buf rem] = strtok(rem);
    [f1 rem] = strtok(rem);
    [f2 rem] = strtok(rem);
    [f3 rem] = strtok(rem);
    vib.ir(3*j + 1) = str2num(f1);
    vib.ir(3*j + 2) = str2num(f2);
    vib.ir(3*j + 3) = str2num(f3);
    for i = 1:1
        tline = fgetl(fid);
    end
    for i = 1:Natoms
        tline = fgetl(fid);
        v = string2num(tline);
        vib.AN(i) = v(2);
        vib.x(i, 3*j+1) = v(3);
        vib.y(i, 3*j+1) = v(4);
        vib.z(i, 3*j+1) = v(5);
        vib.x(i, 3*j+2) = v(6);
        vib.y(i, 3*j+2) = v(7);
        vib.z(i, 3*j+2) = v(8);
        vib.x(i, 3*j+3) = v(9);
        vib.y(i, 3*j+3) = v(10);
        vib.z(i, 3*j+3) = v(11);
        vib.mag(i, 3*j+1) = norm([v(3) v(4) v(5)]);
        vib.mag(i, 3*j+2) = norm([v(6) v(7) v(8)]);
        vib.mag(i, 3*j+3) = norm([v(9) v(10) v(11)]);
    end
    j = j + 1;
end
fclose(fid);

function v = string2num(str)
v = [];
[buf rem] = strtok(str);
v = str2num(buf);
while length(rem) ~= 0
    [buf rem] = strtok(rem);
    v = [v str2num(buf)];
end
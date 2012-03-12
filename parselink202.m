function [AN vp] = parselink202()

files = dir('202-*.txt');
filename = files(end).name;

Natoms = parselink101();
isplot = 0;

AN = zeros(Natoms,1);
vp = zeros(Natoms,3);
fid = fopen(filename);

% find section
while isempty(strfind(fgetl(fid),'Standard'))

end


for ni = 1:4
    tline = fgetl(fid);
end


for ni = 1:Natoms
    tline = fgetl(fid);
    [buf rem] = strtok(tline);
    [buf rem] = strtok(rem);
    AN(ni) = str2num(buf);
    [buf rem] = strtok(rem);
    for nj = 1:3
        [buf rem] = strtok(rem);
        vp(ni,nj) = str2num(buf);
    end
end
fclose(fid);


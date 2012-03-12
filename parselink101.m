function NAtoms = parselink101(filename)
if nargin == 0;
   filename = '101-1.txt'; 
end
[a b c] = fileparts(filename);
if isempty(b)
    files = dir([a '/101*.txt']);
    filename = files(end).name;
end
a = [a '/'];
fid = fopen ([a filename]);
for i = 1:6
    tline = fgetl(fid);
end
NAtoms = 0;
while feof(fid) == 0
    % get frequency number
    tline = fgetl(fid);    
    [buf rem] = strtok(tline);
    if(length(buf) <= 2)
        if(~strcmp(buf,'xx'))
            NAtoms = NAtoms + 1;
        end
    else
        fclose(fid);
        return
    end
end
fclose(fid);
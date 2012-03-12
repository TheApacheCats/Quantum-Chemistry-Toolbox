function extractlinks(filename)
% extracts frequncy information from gaussian log file.
%    1 - Processes route section, builds list of links to execute, and
%       initializes scratch files
%  101 - Reads title and molecule specification
%  103 - Berny optimizations to minima and TS, STQN transition state
%        searches
%  202 - Reorients coordinates, calculates symmetry, and checks
%        variables
%  301 - Generates basis set information
%  302 - Calculates overlap, kinetic, and potential integrals
%  303 - Calculates multipole integrals
%  401 - Forms the initial MO guess
%  502 - Iteratively solves the SCF equations (conven. UHF & ROHF, all
%        direct methods, SCRF)
%  601 - Population and related analyses (including multipole moments)
%  701 - 1-electron integral first or second derivatives
%  702 - 2-electron integral first or second derivatives (sp)
%  703 - 2-electron integral first or second derivatives (spdf)
%  716 - Processes information for optimizations and frequencies
%  801 - Initializes transformation of 2-electron integrals 
% 1002 - Iteratively solves the CPHF equations; computes various
%        properties (including NMR)
% 1101 - Computes 1-electron integral derivatives
% 1102 - Computes dipole derivative integrals
% 1110 - 2-electron integral derivative contribution to Fx
% 9999 - Finalizes calculation and output

if nargin == 0
    filename = dir('*.log');
    filename = filename(1).name;
end
fid = fopen (filename);
x = [];
inLink = false;
% fid2 = fopen('1.txt','w');
vlink = [];
while feof(fid) == 0
    tline = fgetl(fid);
    [buf rem] = strtok(tline);
    if (strcmp(buf,'(Enter'))
        k1 = strfind(rem, '/');
        Nk1 = length(k1);
        k2 = strfind(rem, 'exe');
        slink = rem(k1(Nk1)+2:k2-2);
        nlink = str2num(slink);
        vlink = [vlink nlink];        
        linkfile = sprintf('%i-%i.txt',nlink,sum(vlink==nlink));
        fid2 = fopen(linkfile,'w');
        disp(slink);
        inLink = true;
    end
    if (inLink)
        fprintf(fid2,'%s\n',tline);
%         fprintf(fid2,'\n');
    end
    if (strcmp(buf,'Leave'))
        [buf rem] = strtok(rem);
        [Nlink rem] = strtok(rem);
        if(inLink)
            fclose(fid2);
            inLink = false;
        end
    end
end
fclose(fid);
fclose(fid2);

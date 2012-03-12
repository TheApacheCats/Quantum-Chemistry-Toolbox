function r = qcAtomicRadius(AN, type)
% r = qcAtomicRadius(AN, type)
%
% for use in graphical depictions
% r, raidus of atomic
% AN, atomic number
% type, type of radius (default, emperical from slater)
%
if nargin == 1
    type = 0;
end
switch type
    case 0
        empirical_slater = 1e-12*[25 70 ...
            145 105                                         85  70  65   60 50  70 ...
            180 150                                         125 110 100 100 100 70 ...
            220 180 160 140 135 140 140 140 135 135 135 135 130 125 115 115 115 70];
        r = empirical_slater(AN);
end
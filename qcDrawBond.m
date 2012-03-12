function qcDrawBond(AtomCoord, a1, a2)
line([AtomCoord(a1,1) AtomCoord(a2,1)], ...
    [AtomCoord(a1,2) AtomCoord(a2,2)], ...
    [AtomCoord(a1,3) AtomCoord(a2,3)]);

% 
% function drawbond(v1, v2)
% r = 0.25; % bond radius
% nslices = 40;
% c = [1 1 1]*0.5; % color
% 
% % generate coordinate system
% vz = v2 - v1;
% vx = cross(vz, [0 0 1]);
% vy = cross(vz, vx);
% vx = vx./norm(vx);
% vy = vy./norm(vy);
% 
% % generate faces
% X = [];
% Y = [];
% Z = [];
% for ni = 0:nslices
%     va = r*vx*cos(2*pi*ni/nslices) + r*vy*sin(2*pi*ni/nslices);
%     va = va + v1;
%     vb = r*vx*cos(2*pi*ni/nslices) + r*vy*sin(2*pi*ni/nslices);
%     vb = vb + v2;
%     X = [X; va(1) vb(1)];
%     Y = [Y; va(2) vb(2)];
%     Z = [Z; va(3) vb(3)];
% end
% % plot
% surf(X', Y', Z', 'facecolor', c,'linestyle','none');



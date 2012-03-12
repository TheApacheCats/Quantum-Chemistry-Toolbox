function atomlocations
v = dlmread('atoms.txt');
v(:,1:2) = [];
drawatoms(v,[0 0 0])
vcc = v(9,:) - v(4,:);
vcs = v(5,:) - v(11,:);
vrplane = cross(vcs,vcc);
vrplane = vrplane./sqrt(sum(vrplane.*vrplane));

vx = vrplane*cos(pi/6) + vcs*sin(pi/6);
vx = vx/sqrt(sum(vx.*vx));
vy = cross(vx,vcs);
vy = vy./sqrt(sum(vy.*vy));

r = 7/0.5291772;

drawatoms(v, vx*r);
drawatoms(v, -vx*r);
drawatoms(v, r*(vx*cos(pi/3) + vy*sin(pi/3)));
drawatoms(v, r*(-vx*cos(pi/3) + vy*sin(pi/3)));
drawatoms(v, r*(vx*cos(pi/3) - vy*sin(pi/3)));
drawatoms(v, r*(-vx*cos(pi/3) - vy*sin(pi/3)));



vx/0.250300*7
vy/0.250300*7

function drawatoms(v,v0)
atompairs = [4 5; 9 5; 6 5; 3 4; 9 8; 7 8; 7 3; 8 10; 10 1;6 1; 3 2; 1 2];
for i = 1:length(v)
    v(i,:) = v(i,:) + v0;
end
line([v(11,1) v(5,1)],[v(11,2) v(5,2)],[v(11,3) v(5,3)],'color','y');
for i = 1:length(atompairs)
    line([v(atompairs(i,1),1) v(atompairs(i,2),1)], ...
    [v(atompairs(i,1),2) v(atompairs(i,2),2)], ...
    [v(atompairs(i,1),3) v(atompairs(i,2),3)]);
end

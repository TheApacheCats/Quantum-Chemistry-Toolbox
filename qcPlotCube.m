function qcPlotCube(cubefile, contourlevel)
if nargin == 1
    contourlevel = 0.001;
end
contourlevel = abs(contourlevel);
a = cubefile;
Natoms = size(a.AtomCoord,1);
%% draw stick figure
for ni = 1:Natoms-1
    for nj = ni + 1:Natoms
        v1 = cubefile.AtomCoord(ni, :);
        v2 = cubefile.AtomCoord(nj, :);
        an1 = a.NAtomicNum(ni);
        an2 = a.NAtomicNum(nj);
        drawbond(an1, v1, an2, v2);
    end
end

%% setup coordinates
X = zeros(a.Ne2, a.Ne1, a.Ne3);
Y = zeros(a.Ne2, a.Ne1, a.Ne3);
Z = zeros(a.Ne2, a.Ne1, a.Ne3);
for i = 1:a.Ne1
    for j = 1:a.Ne2
        for k = 1:a.Ne3
            v = (i-1)*a.ve1+(j-1)*a.ve2+(k-1)*a.ve3;
            X(j,i,k) = v(1) + a.vOrigin(1);
            Y(j,i,k) = v(2) + a.vOrigin(2);
            Z(j,i,k) = v(3) + a.vOrigin(3);
        end
    end
end

%% plot volumetric data
p1 = patch(isosurface(X, Y, Z, cubefile.V, contourlevel),'FaceColor','red','EdgeColor','none');
isonormals(X,Y,Z,cubefile.V, p1);
p2 = patch(isosurface(X, Y, Z, cubefile.V, -contourlevel),'FaceColor','blue','EdgeColor','none');
isonormals(X,Y,Z,cubefile.V, p2);
light;
alpha(1);
lighting phong;
daspect([1 1 1]);
axis off;

function drawbond(an1, v1, an2, v2)
if validbond(an1, v1, an2, v2)
    vc = 0.5*(v1 + v2);
    drawline(v1, vc, atomcolor(an1));
    drawline(vc, v2, atomcolor(an2));
end

function drawline(v1, v2, c)
v = [v1; v2];
line(v(:,1), v(:,2), v(:,3), 'color',c);

function isvalid = validbond(an1, v1, an2, v2)
isvalid = 0;
d = norm(v2 - v1);
if an1 > 1 && an2 > 1 % no hydrogen
    if d < 2*2
      isvalid = 1;
    end
else % hydrogen
    if d < 1.5*2
        isvalid = 1;
    end
end 

function c = atomcolor(an)
c = [0 0 0];
switch(an)
    case 1
        c = [1 1 1]*0.8;
    case 6 % carbon
        c = [0 0 0];
    case 8 % oxygen
        c = [1 0 0]*0.8;
end


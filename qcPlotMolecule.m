function qcPlotMolecule(AN, vp, style)
% plots molecule
%
% qcPlotMolecule(AN, vp, style)
if nargin == 0
    [AN vp] = parselink202;
end
%bohr2angstrom = 0.5291772108;
if nargin < 3
    style = 0;
end
if strcmp(style,'wireframe')
    style = 1;
end
AtomCoord = vp;
NAtomicNum = AN;
switch(style)
    case 0 % rendered
        [X Y Z] = sphere(32);
        for ni = 1:length(AN)
            v0 = vp(ni,:);
            c = qcAtomicColor(AN(ni));
            r = qcAtomicRadius(AN(ni))*1e10;
            h = mesh(r*X + v0(1), r*Y + v0(2), r*Z+v0(3),'LineStyle','none','FaceColor',c,'FaceLighting','phong');
            vn(:,:,1) = X;
            vn(:,:,2) = Y;
            vn(:,:,3) = Z;
            set(h,'VertexNormals',vn);
            hold on;
        end
        for ni = 1:length(NAtomicNum)-1
            for nj = ni+1:length(NAtomicNum)
                na1 = NAtomicNum(ni);
                na2 = NAtomicNum(nj);
                v1 = AtomCoord(ni,:);
                v2 = AtomCoord(nj,:);
                if na1 == 1 && na2 == 1 % H to H
                    if(norm(v1-v2) < 1.2)
                      drawrod(v1, v2);
                    end
                elseif(norm(v1-v2) < 2)
                     drawrod(v1, v2);
                end
            end
        end
        light;
    case 1
        % wireframe
        for i = 1:length(NAtomicNum)-1
            for j = i+1:length(NAtomicNum)
                na1 = NAtomicNum(i);
                na2 = NAtomicNum(j);
                v1 = AtomCoord(i,:);
                v2 = AtomCoord(j,:);
                if (NAtomicNum(i) == 1 &&  NAtomicNum(j) == 1) % H to H
                    if(norm(v1-v2) < 1.5)
                        drawbond(na1, v1, na2, v2);
                    end
                elseif (NAtomicNum(i) == 1 &&  NAtomicNum(j) > 1) % H to other
                    if(norm(v1-v2) < 1.5)
                        drawbond(na1, v1, na2, v2);
                    end
                elseif (NAtomicNum(i) > 1 &&  NAtomicNum(j) == 1) % other to H
                    if(norm(v1-v2) < 1.5)
                        drawbond(na1, v1, na2, v2);
                    end
                elseif(NAtomicNum(i) > 18 &&  NAtomicNum(j) > 18) % metal to metal
                    if(norm(v1-v2) < 3)
                        drawbond(na1, v1, na2, v2);
                    end
                elseif(NAtomicNum(i) <= 18 &&  NAtomicNum(j) > 18)
                    if(norm(v1-v2) < 2.7)
                        drawbond(na1, v1, na2, v2);
                    end
                elseif(NAtomicNum(i) > 18 &&  NAtomicNum(j) <= 18)
                    if(norm(v1-v2) < 2.7)
                        drawbond(na1, v1, na2, v2);
                    end
                else
                    if(norm(v1-v2) < 2)
                        drawbond(na1, v1, na2, v2);
                    end
                end
            end
        end
end

daspect([1 1 1]);
set(gca,'CameraTarget', mean(vp));
axis off;


function drawbond(na1, v1, na2, v2)
% draw half of bond in one color and the other in another color
vm = 0.5*(v1 + v2);
c = getatomiccolor(na1);
line([v1(1) vm(1)], [v1(2) vm(2)], [v1(3) vm(3)], 'color', c);
c = getatomiccolor(na2);
line([vm(1) v2(1)], [vm(2) v2(2)], [vm(3) v2(3)], 'color', c);

function c = getatomiccolor(na)
% determine which color atoms get
switch(na)
    case 1 % hydrogen
        c = [1 1 1]*0.9;
    case 6 % carbon
        c = [1 1 1]*0.1;
    case 16
        c = [0 0 1];
    case 79 % copper
        c = [1 0.5 0];
    otherwise
        c = [0 0 0];
end

function drawrod(v0, v1)
vz = v1 - v0;
vz = vz/norm(vz);
vx = cross(vz, [0 0 1]);
if norm(vx)<0.5
    vx = cross(vz, [0 1 0]);
end
vx = vx/norm(vx);
vy = cross(vz,vx);
N = 16;
t = linspace(0,2*pi,N);
d0 = [];
d1 = [];
r = 0.1;
for ni = 1:N
    t0 = t(ni);
    d0 = [d0; v0 + r*vx*cos(t0)+r*vy*sin(t0)];
    d1 = [d1; v1 + r*vx*cos(t0)+r*vy*sin(t0)];
end
X = [d0(:,1) d1(:,1)];
Y = [d0(:,2) d1(:,2)];
Z = [d0(:,3) d1(:,3)];
mesh(X, Y, Z,'facecolor',[1 1 1]*0.5,'edgecolor','none');


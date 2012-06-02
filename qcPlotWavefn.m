function qcPlotWavefn(surface1, surface2)
N1 = length(surface1);
N2 = length(surface2);
for i = 1:N1/2
    v1(i,1) = surface1(2*i, 1);
    v1(i,2) = -1*surface1(2*i, 2);
    v1(i,3) = -1*surface1(2*i, 3);
end
for i = 1:N1/6
    f1(i,1) = 3*i - 2;
    f1(i,2) = 3*i - 1;
    f1(i,3) = 3*i;
end
for i = 1:N2/2
    v2(i,1) = surface2(2*i, 1);
    v2(i,2) = -1*surface2(2*i, 2);
    v2(i,3) = -1*surface2(2*i, 3);
end
for i = 1:N2/6
    f2(i,1) = 3*i - 2;
    f2(i,2) = 3*i - 1;
    f2(i,3) = 3*i;
end

patch('Vertices', 20.*v1, 'Faces', f1);
patch('Vertices', 20.*v2, 'Faces', f2);
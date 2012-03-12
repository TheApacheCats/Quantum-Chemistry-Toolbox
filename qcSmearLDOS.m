function [newLDOS] = qcSmearLDOS(x, LDOS, sigma)
q = 1.60217646e-19;
kb = 1.3806503e-23;
N = length(LDOS);
newLDOS = zeros(1,length(x));
for i = 1:N
    newLDOS = newLDOS + exp(-(x-LDOS(i)).^2/(2*sigma^2))/(sigma*sqrt(2*pi));
end
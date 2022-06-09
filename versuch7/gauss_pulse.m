function [jvalue] = gauss_pulse(t, fmax)

% value
% omega = 2*pi*fmax;
sigma = sqrt(log(10))/(pi*fmax);
t0 = sigma*sqrt(6*log(10));
tm = t - t0;
jvalue = exp(-tm.^2 ./ (2*sigma^2));

function [ jvalue ] = trapez_pulse(time, trise, thold, tfall)

% number of time points
% nt = 

t1 = trise;
t2 = trise + thold;
t3 = trise + thold + tfall;

jvalue = zeros(1,nt);

% trapez value
for k = 1:nt
    t = time(k);
    if (0 <= t && t < t1)
        % jvalue(k) =
    elseif (t1 <= t && t < t2)
        % jvalue(k) =
    elseif ( t2 <= t && t < t3)
        % jvalue(k) = 
    else
        % jvalue(k) = 
end

end


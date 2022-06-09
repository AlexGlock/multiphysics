function [hnew,enew]=leapfrog(hold, eold, js, Mmui, Meps, c, Rmat, dt)

% Berechnen der neuen magnetischen Spannung
hnew = hold - dt*Mmui*c*eold;

% Berechnen der neuen elektrischen Spannung
% enew = eold + dt*nullInv(Meps)*(c'*hnew - js);
enew = nullInv((nullInv(Rmat) + Meps/dt)) * (Meps/dt*eold + c'*hnew - js);

end
function [hnew,enew]=leapfrog(hold,eold,js,Mmui,Mepsi,c,dt)

% Berechnen der neuen magnetischen Spannung
hnew = hold - dt*Mmui*C*eold;

% Berechnen der neuen elektrischen Spannung
enew = eold + dt*Mepsi*(C'*hnew - js);

end

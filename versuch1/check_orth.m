%Skript zur Überprüfung der Orthogonalität

% Setzen der parameter n, ord, bc, L
n=6;
ord=2;
bc=0;
L=1;

% Erstellen der CC matrix
cc = createCC(n, ord, bc);

% Gitterschrittweite bestimmen
dx = L/(n-1);

% Lösen der Eigenwertgleichung mit solveCC
[kx, modes] = solveCC(cc, dx);

% Überprüfung der Orthogonalität der Eigenvektoren
A = zeros(n,n);
for i = 1:n
    for j = 1:n
        A(i,j) = modes(:,i)' * modes(:,j);
    end
end

imagesc(A);
colorbar
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf orth.pdf
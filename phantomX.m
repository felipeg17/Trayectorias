l = [14.5, 10.7, 10.7, 9]; % Longitudes eslabones
% Definicion del robot RTB
L(1) = Link('revolute','alpha',pi/2,'a',0,   'd',l(1),'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',0,   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
PhantomX = SerialLink(L,'name','Px');
% roty(pi/2)*rotz(-pi/2)
PhantomX.tool = [0 0 1 l(4); -1 0 0 0; 0 -1 0 0; 0 0 0 1];
ws = [-50 50];
% Graficar robot
PhantomX.plot([0 0 0 0],'notiles','noname');
hold on
trplot(eye(4),'rgb','arrow','length',15,'frame','0')
axis([repmat(ws,1,2) 0 60])
PhantomX.teach()
%%
% Dibuja marcos coordenados
q = zeros(1,4);
M = eye(4);
for i=1:PhantomX.n
    M = M * L(i).A(q(i));
    trplot(M,'rgb','arrow','frame',num2str(i),'length',15)
end
%%
% Uso de variables simbolicas para calcular la Cinematica Directa
syms q1 q2 q3 q4 as real
%%
T01 = L(1).A(q1)
%%
T01(1,2) = 0;
T01(2,2) = 0;
T01(3,3) = 0;
T01
%%
T12 = L(2).A(q2)
T23 = L(3).A(q3)
T34 = L(4).A(q4)
%%
T01*T12*T23*T34
T04 = simplify(T01*T12*T23*T34)
T0tool = T04*PhantomX.tool
%%
qt = deg2rad([30 -60 -60 30]);
PhantomX.fkine(qt)
double(subs(T0tool,[q1 q2 q3 q4],qt))






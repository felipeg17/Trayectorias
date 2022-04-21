l = [14.5, 10.7, 10.7, 9]; % Longitudes eslabones

% Definicion del robot RTB
L(1) = Link('revolute','alpha',0,   'a',0, 'd',l(1),'offset',0,'qlim',[-3*pi/4 3*pi/4],'modified');
L(2) = Link('revolute','alpha',pi/2,'a',0, 'd',0, 'offset',pi/2,'qlim',[-3*pi/4 3*pi/4],'modified');
L(3) = Link('revolute','alpha',0,   'a',l(2),'d',0, 'offset',0,'qlim',[-3*pi/4 3*pi/4],'modified');
L(4) = Link('revolute','alpha',0,   'a',l(3),'d',0, 'offset',0,'qlim',[-3*pi/4 3*pi/4],'modified');
PhantomX = SerialLink(L,'name','Px');
PhantomX.tool = [0 0 1 l(4); -1 0 0 0; 0 -1 0 0; 0 0 0 1];
handles.robot = PhantomX;
ws = [-50 50];
% Graficar robot
PhantomX.plot([0 0 0 0],'notiles','noname');
hold on
[x_cyl, y_cyl, z_cyl] = cylinder(1.2,20);
z_cyl = l(1)*z_cyl;
surf(x_cyl,y_cyl,z_cyl,'EdgeColor','none','FaceColor','blue','FaceAlpha',0.95)
trplot(eye(4),'rgb','arrow','length',15,'frame','0')
axis([repmat(ws,1,2) 0 60])
PhantomX.teach()
%%
qt = deg2rad([60 -80 20 25]);
Tt = PhantomX.fkine(qt);
%%
% Desacople
T = Tt;
Tw = T - l(4)*T(1:4,3); % MTH Wrist

% Solucion q1
q1 = atan2(Tw(2,4),Tw(1,4));
%rad2deg(q1)

% Solución 2R
h = Tw(3,4) - l(1);
r = sqrt(Tw(1,4)^2 + Tw(2,4)^2);

% Codo abajo
the3 = acos((r^2+h^2-l(2)^2-l(3)^2)/(2*l(2)*l(3)));
the2 = atan2(h,r) - atan2(l(3)*sin(the3),l(2)+l(3)*cos(the3));

q2d = -(pi/2-the2);
q3d = the3;

% Codo arriba
the3 = acos((r^2+h^2-l(2)^2-l(3)^2)/(2*l(2)*l(3)));
the2 = atan2(h,r) + atan2(l(3)*sin(the3),l(2)+l(3)*cos(the3));

q2u = -(pi/2-the2);
q3u = -the3;

%disp(rad2deg([q2d q3d; q2u q3u]))

% Solucion de q4
Rp = (rotz(q1))'*T(1:3,1:3);
pitch = atan2(Rp(3,1),Rp(1,1));

q4d = pitch - q2d - q3d;
q4u = pitch - q2u - q3u;
%disp(rad2deg([q4d q4u]))

qinv(1,1:4) = [q1 q2u q3u q4u];
qinv(2,1:4) = [q1 q2d q3d q4d];
disp(rad2deg(qinv))
%%
% Solucion usando un doble 2R
% Codo abajo
h2 = T(3,4) - l(1) - l(2)*sin(pi/2+q2d);
r2 = sqrt(T(1,4)^2+T(2,4)^2) - l(2)*cos(pi/2+q2d);
the4d = acos((r2^2+h2^2-l(3)^2-l(4)^2)/(2*l(3)*l(4)));

% Codo arriba
h2 = T(3,4) - l(1) - l(2)*sin(pi/2+q2u);
r2 = sqrt(T(1,4)^2+T(2,4)^2) - l(2)*cos(pi/2+q2u);
the4u = acos((r2^2+h2^2-l(3)^2-l(4)^2)/(2*l(3)*l(4)));
%%
% Calculo de phi
phi = atan2((T(3,4)-Tw(3,4)),(sqrt(T(1,4)^2+T(2,4)^2)-sqrt(Tw(1,4)^2 + Tw(2,4)^2)));
% ajsute por offset de q2
phi = phi - pi/2;
the4dd = phi - q2d - q3d;
the4uu = phi - q2u - q3u;


%%
q_inv = invKinPx_m(T,l);
%%
T0 = transl(15,10,18)*trotz(pi/6)*troty(pi/2);
T1 = transl(15,-10,18)*trotz(-pi/6)*troty(pi/2);
% ctraj
T01 = ctraj(T0,T1,20);
% ciclo para calcular y graficar el robot
pause(3)
for i=1:20
   qinv = invKinPx_m(T01(:,:,i),l);
   PhantomX.plot(qinv(2,:),'notiles','noname')
   plot3(T01(1,4,i),T01(2,4,i),T01(3,4,i),'ro')
   q_inv(i,:) = qinv(1,:);
   %pause(0.5)
end
%%
figure(2)
plot(q_inv(:,:),'lineWidth',2)
grid on
axis([1 20 -pi pi])

%% Robot 2R
% mdl_twolink;
L(1) = Link([0 0 1 0 0]);
L(2) = Link([0 0 1 0 0]);
dosR = SerialLink(L,'name','2R');
%% Elipsoide
%q = [0:pi/20:pi/2; zeros(1,11)];
q = [linspace(0,pi/4,10); linspace(0,pi/2,10)];
figure
grid on
hold on
trplot(eye(4),'rgb')
axis([-3 3 -3 3])

for i=1:length(q)
    J = dosR.jacob0(q(:,i));
    J = [J(1,:); J(2,:)];
    C = dosR.fkine(q(:,i));
    dosR.plot(q(:,i)')
    plot_ellipse(J*J',C(1:2,4))
    pause(1)
end
%% Trapezoidal
q_init = -pi/4;
q_fin = pi/2;
A_trap = q_fin - q_init;
t_max = 5;
dq_max =  A_trap*(2/(1.5*t_max))*1.2; % Velocidad Maxima
disp(dq_max)
T = 0:0.1:5;
[q_trap, dq_trap, d2q_trap] = lspb(-pi/4, pi/2,T,dq_max);
%%
figure
plot(T,q_trap,'linewidth',2)
hold on
plot(T,dq_trap,'linewidth',2)
plot(T,d2q_trap,'linewidth',2)
legend('q','dq','d2q')
grid on;


%% Lspb Linear segment with parabolic blend
% Para robot de 2 gdl.
t1 = linspace(0,1,20);
t2 = linspace(1,2,20);
% Velocidades 
v1 = [1 0.9]; % [Vjoint1_ini Vjoint_fin] 
v2 = [2 1.8]; % [Vjoint2_ini Vjoint2_fin] 
%  Segmento Subida 
q_init1 = [0        0];    % [ joint_1  joint_2]
q_fin1  = [pi/4  pi/2];    % [ joint_1  joint_2]

%  Segmento Bajada      
q_init2 = [pi/4  pi/2];     
q_fin2  = [pi/24 pi/12];
%% 
% [q_trap, dq_trap, d2q_trap] = lspb(q_init2(2),  q_fin2(2), t1, v2(2));
% figure
% plot(t1,q_trap,'linewidth',2)
% hold on
% plot(t1,dq_trap,'linewidth',2)
% plot(t1,d2q_trap,'linewidth',2)
% legend('q','dq','d2q')
% grid on;

%%
% Joint 1
[q1_s1, dq1_s1, d2q1_s1] = lspb(q_init1(1), q_fin1(1), t1, v1(1)); % segmento 1
[q1_s2, dq1_s2, d2q1_s2] = lspb(q_init2(1), q_fin2(1), t1, v1(2)); % segmento 2

% Joint 2
[q2_s1, dq2_s1, d2q2_s1] = lspb(q_init1(2), q_fin1(2), t1, v2(1)); 
[q2_s2, dq2_s2, d2q2_s2] = lspb(q_init2(2), q_fin2(2), t1, v2(2));

figure
subplot(3,1,1)
plot([t1 t2],[q1_s1; q1_s2],'linewidth',2)
hold on
plot([t1 t2],[q2_s1; q2_s2],'r','linewidth',2)
grid on
legend('q1','q2')
subplot(3,1,2)
plot([t1 t2],[dq1_s1; dq1_s2],'linewidth',2)
hold on
plot([t1 t2],[dq2_s1; dq2_s2],'r','linewidth',2)
grid on
legend('dq1','dq2')
subplot(3,1,3)
plot([t1 t2],[d2q1_s1; d2q1_s2],'linewidth',2)
hold on
plot([t1 t2],[d2q2_s1; d2q2_s2],'r','linewidth',2)
grid on
legend('d2q1','d2q2')
xlabel('Tiempo (s)')

q1_s = [q1_s1   ; q1_s2];
q2_s = [q2_s1   ; q2_s2];
dq1_s = [dq1_s1 ; dq1_s2];
dq2_s = [dq2_s1 ; dq2_s2];

disp('mean speed dq1')
disp(mean(dq1_s1)/max(dq1_s1))

%% Animacion LSPB
figure
hold on
trplot(eye(4),'rgb')
axis([-3 3 -3 3 -1 1])
axis equal
for i=1:length(q1_s)
    punto = dosR.fkine([q1_s(i) q2_s(i)]);
    dosR.plot([q1_s(i) q2_s(i)])
    plot3(punto(1,4),punto(2,4),punto(3,4),'c.')
    
    %view(3)
    %pause(0.1)
end



%% TPOLY 

% Joint 1
[q1_s1, dq1_s1, d2q1_s1] = tpoly(q_init1(1), q_fin1(1), t1); % Seg 1
[q1_s2, dq1_s2, d2q1_s2] = tpoly(q_init2(1), q_fin2(1), t1); % Seg 2
% Joint 2
[q2_s1, dq2_s1, d2q2_s1] = tpoly(q_init1(2), q_fin1(2), t1); % Seg 1
[q2_s2, dq2_s2, d2q2_s2] = tpoly(q_init2(2), q_fin2(2), t1); % Seg 2

figure
hold on
subplot(3,1,1)
plot([t1 t2],[q1_s1; q1_s2],'linewidth',2)
hold on
plot([t1 t2],[q2_s1; q2_s2],'r','linewidth',2)
grid on
legend('q1','q2')
subplot(3,1,2)
plot([t1 t2],[dq1_s1; dq1_s2],'linewidth',2)
hold on
plot([t1 t2],[dq2_s1; dq2_s2],'r','linewidth',2)
grid on
legend('dq1','dq2')
subplot(3,1,3)
plot([t1 t2],[d2q1_s1; d2q1_s2],'linewidth',2)
hold on
plot([t1 t2],[d2q2_s1; d2q2_s2],'r','linewidth',2)
grid on
legend('d2q1','d2q2')
xlabel('Tiempo (s)')

q1_s = [q1_s1; q1_s2];
q2_s = [q2_s1; q2_s2];
dq1_s = [dq1_s1; dq1_s2];
dq2_s = [dq2_s1; dq2_s2];

disp('mean speed dq1')
disp(mean(dq1_s1)/max(dq1_s1))


%% Animacion Tpoly
figure
hold on
trplot(eye(4),'rgb')
axis([-3 3 -3 3 -1 1])
for i=1:length(q1_s)
    punto = dosR.fkine([q1_s(i) q2_s(i)]);
    dosR.plot([q1_s(i) q2_s(i)])
    plot3(punto(1,4),punto(2,4),punto(3,4),'c.')
    %view(3)
    %pause(0.1)
end


%% Trayectorias - Interpolacion espacio de las articulaciones - 5th pol
%pos = mtraj(@lspb,[2 0],[1 1],0:0.1:1);
[q_traj, dq_traj] = jtraj([0 0],[pi/2 pi/4],50);
figure
hold on
trplot(eye(4),'rgb')
axis([-3 3 -3 3 -1 1])
for i=1:length(q_traj)
    punto = dosR.fkine(q_traj(i,:));
    dosR.plot(q_traj(i,:))
    plot3(punto(1,4),punto(2,4),punto(3,4),'b*')
    view(3)
    pause(0.1)
end



figure
subplot(2,1,1)
plot(q_traj,'linewidth',2)
grid on
legend('q1','q2')
subplot(2,1,2)
plot(dq_traj,'linewidth',2)
grid on
legend('dq1','dq2')
xlabel('Paso de tiempo')

%% Interpolacion espacio de la tarea - Movimiento cartesiano
%pos = mtraj(@lspb,[2 0],[1 1],0:0.1:1);
T_traj = ctraj(dosR.fkine([-pi/12 pi/6]),dosR.fkine([0 pi/2]),20);

q_ctraj = dosR.ikunc(T_traj(:,:,:));

figure
hold on
trplot(eye(4),'rgb')
axis([-3 3 -3 3 -1 1])
for i=1:length(q_ctraj)
    punto = dosR.fkine(q_ctraj(i,:));
    dosR.plot(q_ctraj(i,:))
    plot3(punto(1,4),punto(2,4),punto(3,4),'r*')
    %view(3)
    pause(0.5)
end
figure
plot(q_ctraj,'linewidth',2)
grid on
legend('q1','q2')
xlabel('Paso de tiempo')

%% Multiples segmentos - Via points en el espacio articular
%via = [-pi/4 pi/2; deg2rad(-29) deg2rad(87); deg2rad(-7.2) deg2rad(72);...
%       deg2rad(29) deg2rad(29); deg2rad(-18) deg2rad(120)];
via = [invKin2R(2,0,1,1,0);
    invKin2R(1.5,0,1,1,0);
    invKin2R(1.5,0.2,1,1,0);
    invKin2R(1.5,0.4,1,1,0);
    invKin2R(1.5,0.6,1,1,0);
    invKin2R(1.5,0.8,1,1,0);
    invKin2R(1.5,1,1,1,0);
    invKin2R(1.5,1.2,1,1,0);
    invKin2R(1.2,.9,1,1,0)];

q_s= mstraj(via,[],[1 1 1 1 1 1 1 1 1],[0 0],0.1,0.5);
figure
hold on
trplot(eye(4),'rgb')
axis([-1 2 -1 2])
% punto = dosR.fkine(via(1,:));
% plot3(punto(1,4),punto(2,4),punto(3,4),'kx')
% punto = dosR.fkine(via(2,:));
% plot3(punto(1,4),punto(2,4),punto(3,4),'kx')
% punto = dosR.fkine(via(3,:));
% plot3(punto(1,4),punto(2,4),punto(3,4),'kx')
% punto = dosR.fkine(via(4,:));
% plot3(punto(1,4),punto(2,4),punto(3,4),'kx')
% punto = dosR.fkine(via(5,:));
% plot3(punto(1,4),punto(2,4),punto(3,4),'kx')

%vidObj = VideoWriter('uno.avi');
%open(vidObj);
for j = 1:size(via,1)
    punto = dosR.fkine(via(j,:));
    plot3(punto(1,4),punto(2,4),punto(3,4),'kx')
end
axis([-3 3 -3 3 -1 1])
for i=1:length(q_s)
    punto = dosR.fkine(q_s(i,:));
    dosR.plot(q_s(i,:))
    plot3(punto(1,4),punto(2,4),punto(3,4),'-o','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',2)
    %view(3)
    %pause(0.1)
    axis([-1 3 -1 2])
    M(i) = getframe();
    %writeVideo(vidObj,M(i));
end
%close(vidObj);

%%
T = 0:0.05:9-0.05;
figure
plot(q_s,'--rs','LineWidth',2,...
                       'MarkerEdgeColor','c',...
                       'MarkerFaceColor','b',...
                       'MarkerSize',10)
hold on
grid on
for i=1:9
    plot(i,via(i,1),'--rs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',10)
    plot(i,via(i,2),'--rs','LineWidth',2,...
                       'MarkerEdgeColor','b',...
                       'MarkerFaceColor','r',...
                       'MarkerSize',10)
end
legend('q1','q2')
xlabel('Tiempo')
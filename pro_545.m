p = quintic_p([0 0.5],[0 0.5],[0 2],[0 1])
t = linspace(0,1,50);
T = [t.^0; t.^1; t.^2; t.^3; t.^4; t.^5];
q_t = p(1,:)*T;
dq_t = p(2,:)*T;
d2q_t = p(3,:)*T;
d3q_t = p(4,:)*T;

subplot(4,1,1)
plot(t,q_t,'b')
grid on
hold on
subplot(4,1,2)
plot(t,dq_t,'r')
grid on
hold on
subplot(4,1,3)
plot(t,d2q_t,'m')
grid on
hold on
subplot(4,1,4)
plot(t,d3q_t,'c')
grid on
hold on


p = quadri_p([0.5 2.5],[0.5 0.5],[2 0],[1 2])
t = linspace(1,2,50);
T = [t.^0; t.^1; t.^2; t.^3; t.^4;];
q_t = p(1,:)*T;
dq_t = p(2,:)*T;
d2q_t = p(3,:)*T;
d3q_t = p(4,:)*T;

subplot(4,1,1)
plot(t,q_t,'b')
grid on
hold on
subplot(4,1,2)
plot(t,dq_t,'r')
grid on
hold on
subplot(4,1,3)
plot(t,d2q_t,'m')
grid on
hold on
subplot(4,1,4)
plot(t,d3q_t,'c')
grid on
hold on


p = quintic_p([2.5 3],[0.5 0],[d2q_t(length(t)) 0],[2 3])
t = linspace(2,3,50);
T = [t.^0; t.^1; t.^2; t.^3; t.^4; t.^5];
q_t = p(1,:)*T;
dq_t = p(2,:)*T;
d2q_t = p(3,:)*T;
d3q_t = p(4,:)*T;

subplot(4,1,1)
plot(t,q_t,'b')
grid on
legend('q')
subplot(4,1,2)
plot(t,dq_t,'r')
grid on
legend('dq')
subplot(4,1,3)
plot(t,d2q_t,'m')
grid on
legend('d2q')
subplot(4,1,4)
plot(t,d3q_t,'c')
grid on
legend('d3q')
xlabel('Tiempo')
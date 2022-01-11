%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula polinomio c?bico de interpolaci?n en el espacio articular
% Entradas:
% q0 = initial position
% qf = final position
% dq0 = initial velocity
% dqf = final velocity
% t0 = initial time
% tf = final time
% Salidas:
% a = Coeficientes polinomio de interpolaci?n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function profiles = cubic_p(q,dq,t)
q0 = q(1); 
q1 = q(2); 
v0 = dq(1); 
v1 = dq(2); 
t0 = t(1); 
tf = t(2);

M = [ 1 t0 t0^2 t0^3;
      0 1  2*t0 3*t0^2;
      1 tf tf^2 tf^3;
      0 1  2*tf 3*tf^2];
  
b = [q0; v0; q1; v1];
%a = inv(M)*b;
a = M\b;

% qd = reference position trajectory
% vd = reference velocity trajectory
% ad = reference acceleration trajectory

% qd = a(1).*c + a(2).*t +a(3).*t.^2 + a(4).*t.^3;
% vd = a(2).*c +2*a(3).*t +3*a(4).*t.^2;
% ad = 2*a(3).*c + 6*a(4).*t;

profiles = [a(1)   a(2)   a(3)   a(4);
            a(2)   2*a(3) 3*a(4) 0;
            2*a(3) 6*a(4) 0      0;
            6*a(4) 0      0      0];
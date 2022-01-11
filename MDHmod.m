function DH = MDHmod(alpha,a,d,theta)
% Obtiene la matriz de tranformacion homogeneas  utilizando la con
% convencion de DH modificada
% Sintaxis
% A0n = MDHstd(tetha, d, a, alfa)

% A0n = Matriz de trasformacion homogenea
% A0n =j T(Rz)(theta)*T(Transz)(d)*T(Transx)(a)*T(Rx)(alfa) 

if length(alpha)>=4
    theta=alpha(4);
    d=alpha(3);
    a= alpha(2);
    alpha= alpha(1);
else
    alpha = alpha;
end


DH = [cos(theta)           ,            -sin(theta),           0,  a;
      sin(theta)*cos(alpha),  cos(theta)*cos(alpha), -sin(alpha), -sin(alpha)*d;
      sin(theta)*sin(alpha),  cos(theta)*sin(alpha),  cos(alpha),  cos(alpha)*d;
               0,                      0,                      0,             1];

    
return;
function q = invKin2R (x,y,l1,l2,elbow)
sg = 1;
if elbow > 0
    sg = -1;
end
D = (x^2+y^2-l1^2-l2^2)/(2*l1*l2);
q2 = atan2(sg*sqrt(1-D^2),D);
q1 = atan2(y,x)-atan2(l2*sin(q2),l1+l2*cos(q2));
q = [q1 q2];
end
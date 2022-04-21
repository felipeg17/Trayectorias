%%
rosinit; %Conexion con nodo maestro
%%
velPub = rospublisher('/turtle1/cmd_vel','geometry_msgs/Twist'); %Creacion publicador
velMsg = rosmessage(velPub); %Creacion de mensaje
%%
velMsg.Linear.X = 1; %Valor del mensaje
velMsg.Angular.Z = 1;
send(velPub,velMsg); %Envio
% pause(1)
%%
PoseSvcClient = rossvcclient('/turtle1/teleport_absolute'); %Creación de cliente de pose y posición
PseMsg = rosmessage(PoseSvcClient); %Creación de mensaje
%%
PseMsg.X = 1; %Especifica posición en X
PseMsg.Y = 1; %Especifica posición en Y
PseMsg.Theta = 0; %Especifica posición angular Theta
call(PoseSvcClient,PseMsg); % llama el servicio con el mensaje definido arriba
pause(1)
%%
rosshutdown;
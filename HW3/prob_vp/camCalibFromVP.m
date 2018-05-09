function [f, u0, v0, R] = camCalibFromVP(VP)
% === Input === 
% VP: [2 x 3] vanishing points 
%
% === Output === 
% f - focol length
% u0, v0 - principle center
% R - rotation matrix
vp_x = [VP(:,1)', 1];
vp_y = [VP(:,2)', 1];
vp_z = [VP(:,3)', 1];
syms focal u v
K = [focal,0,u;0,focal,v;0,0,1];
eqn1 = vp_x*inv(K')*inv(K)*vp_y' == 0;
eqn2 = vp_x*inv(K')*inv(K)*vp_z' == 0;
eqn3 = vp_y*inv(K')*inv(K)*vp_z' == 0;
result = solve(eqn1,eqn2,eqn3,focal,u,v);
f = double(abs(result.focal));
u0 = double(result.u);
v0 = double(result.v);

% solve for camera rotation matrix
K_prime = [f,0,u0;0,f,v0;0,0,1];
R(:,1) = K_prime\vp_x';
R(:,2) = K_prime\vp_y';
R(:,3) = K_prime\vp_z';
% normalize to 1
R(:,1) = R(:,1)/norm(R(:,1));
R(:,2) = R(:,2)/norm(R(:,2));
R(:,3) = R(:,3)/norm(R(:,3));

end
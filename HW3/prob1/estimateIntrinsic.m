function [f, u0, v0, R] = estimateIntrinsic( vp )
% Calibrating the camera using the orthogonal vanishing points
% solve for camera focal length and optical center
%
% === Input === 
% VP: [3 x 3] vanishing points 
%
% === Output === 
% f - focal length
% u0, v0 - principle center
% R - rotation matrix

syms focal u v
K = [focal,0,u;0,focal,v;0,0,1];
eqn1 = vp(:,1)'*inv(K')*inv(K)*vp(:,2) == 0;
eqn2 = vp(:,1)'*inv(K')*inv(K)*vp(:,3) == 0;
eqn3 = vp(:,2)'*inv(K')*inv(K)*vp(:,3) == 0;
result = solve(eqn1,eqn2,eqn3,focal,u,v);
f = double(abs(result.focal));
u0 = double(result.u);
v0 = double(result.v);

% solve for camera rotation matrix
vp_x = vp(:,1);
vp_y = vp(:,3);
vp_z = vp(:,2);
K_prime = [f,0,u0;0,f,v0;0,0,1];
R(:,1) = K_prime\vp_x;
R(:,2) = K_prime\vp_y;
R(:,3) = K_prime\vp_z;
% each column normalize to 1
R(:,1) = R(:,1)/norm(R(:,1));
R(:,2) = R(:,2)/norm(R(:,2));
R(:,3) = R(:,3)/norm(R(:,3));
end


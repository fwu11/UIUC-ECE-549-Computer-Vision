function [F] = eightPointAlgorithm(X,X_prime,T,T_prime,index)
    %normalize image coordinates
    x = T*X;
    x_prime = T_prime*X_prime;
    
    u = x(1,index);
    v = x(2,index);
    u_prime = x_prime(1,index);
    v_prime = x_prime(2,index);

    % construct A matrix
    A = zeros(8,9);
    for i = 1:8
       A(i,:) = [u(i)*u_prime(i), u(i)*v_prime(i), u(i), v(i)*u_prime(i), v(i)*v_prime(i), v(i),u_prime(i),v_prime(i),1]; 
    end

    % 8 point algorithm
    % solve f from Af = 0
    [~,~,V] = svd(A);
    f = V(:,end);
    F = reshape(f,[3 3])';

    % Resolve det(F)=0 constraint
    [U,S,V] = svd(F);
    S(3,3) = 0;
    F = U*S*V';
    
    %De-normalize
    F = T'*F*T_prime;
    
    %unit length
    F = F/(sqrt(sum(sum(F.^2))));
    
end


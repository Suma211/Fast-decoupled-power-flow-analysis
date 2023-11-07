function [Y_m,Theta,Y_mag,B,G]=Ybus_matrix(Busdata,Linedata,nb,nm)
% Y bus matrix computation
Y_m=zeros(nb);   %Y matrix
B_m=zeros(nb);   %B matrix
Z_fb=Linedata(:,2);  %  from bus
Z_tb=Linedata(:,3);  %  to bus
R=Linedata(:,8);  % Resistance 
X=Linedata(:,9);   % Reactance
B=Linedata(:,10).*1j;  %susceptance
tran_rt=Linedata(:,16);   %tansformer turns ratio
shun_cap=Busdata(:,15)+(Busdata(:,16)*1i);  %Shunt capacitor at bus 9
Z=R+1j*X;  % line Impedance
Y=1./Z;  % Line Admittance 
for n=1:nm  %nm is no of lines 
    if tran_rt~=0  % finding off diagonal elements of trans adm matrix
        Y_m(Z_fb(n),Z_tb(n))=-1/tran_rt(n)*Y(n);
        Y_m(Z_tb(n),Z_fb(n))=Y_m(Z_fb(n),Z_tb(n));
        Y_m(Z_fb(n),Z_fb(n))=Y_m(Z_fb(n),Z_fb(n))+Y(n)*(1/tran_rt(n))^2;
        Y_m(Z_tb(n),Z_tb(n))=Y_m(Z_tb(n),Z_tb(n))+Y(n);
    else
        Y_m(Z_fb(n),Z_tb(n))=-Y(n);  
        Y_m(Z_tb(n),Z_fb(n))=Y_m(Z_fb(n),Z_tb(n));
        Y_m(Z_fb(n),Z_fb(n))=Y_m(Z_fb(n),Z_fb(n))+Y(n)+B(n)/2;
        Y_m(Z_tb(n),Z_tb(n))=Y_m(Z_tb(n),Z_tb(n))+Y(n)+B(n)/2;
    end 
end 
for r=1:nb  % YBus plus diagonal valid only for 9 th bus
    Y_m(r,r)=Y_m(r,r)+shun_cap(r);
end
[Theta, Y_mag] = cart2pol(real(Y_m), imag(Y_m)); % get angle and magnitude of admittance matrix
 B = imag(Y_m); % susceptance matrix
 G = real(Y_m); % conductance matrix
end
 

        



      
      
      
    
      
 
      
      
          
      




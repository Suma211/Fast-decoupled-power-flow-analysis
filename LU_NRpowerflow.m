function[PQ,PV,nPQ,nPV,P_cal,Q_cal,V_result]= LU_NRpowerflow(S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin)
% Types of buses
Slack = find(Busdata(:,4)==3);  % Slack Bus
PQ= find(Busdata(:,4)==0|Busdata(:,4)==1);  % PQ bus
PV= find (Busdata(:,4)==2);  %PV Bus
nSlack=length(Slack);
nPQ=length(PQ);
nPV=length(PV);
[Y_m,Theta,Y_mag,B,G]=Ybus_matrix(Busdata,Linedata,nb,nm);
% Changing the Ybus matrix from rectangular to polar form
[Theta, Y_mag] = cart2pol(real(Y_m), imag(Y_m)); % get angle and magnitude of admittance matrix
 B = imag(Y_m); % susceptance matrix
 G = real(Y_m); % conductance matrix
% Initializing the parameters
V_mag= Busdata(:,12); %Initial Voltage
V_mag(~V_mag)=1;   %replacing V_mag with value 1
V_delta=zeros(nb,1); %Initial angle
P_sch=P_gen-P_load;  % net power scheduled at bus
Q_sch=Q_gen-Q_load;
dif_Voltage= zeros(nb-1+nPQ,1);

% Power calculation formulas
P_cal=zeros(nb,1);  %initialize active power vector
Q_cal=zeros(nb,1);  %initialize reactive power vector
     for i=1:nb
         for j=1:nb
             P_cal(i)=P_cal(i)+V_mag(i)*V_mag(j)*Y_mag(i,j)*cos(Theta(i,j)-V_delta(i)+V_delta(j));
             Q_cal(i)=Q_cal(i)-V_mag(i)*V_mag(j)*Y_mag(i,j)*sin(Theta(i,j)-V_delta(i)+V_delta(j));
         end 
     end


 %% Newton raphson power flow calculation
 tol_max=0.01; % iteration tolerance of the solution
 iter=0; %times of iteration
 tol=1; %initial value of tol
 
 while (tol>tol_max)
    [P_cal,Q_cal]=cal_PQ(V_mag,Y_mag,Theta,V_delta,nb); %calculate the power at buses 
    [dif_PQ]=difference_PQ(P_sch,Q_sch,P_cal,Q_cal,PQ,nPQ); % mismatches vector
    [J]=Jacobian_Matrix(V_mag,P_cal,Q_cal,Y_mag,Theta, V_delta,nb,PQ,nPQ,B,G); %call the Jacobian matrix
    [dif_Voltage]=LU_factor_PQ(J,dif_PQ); %dif_Voltage=inv(J)*dif_PQ; %get correction vector
    dif_D=dif_Voltage(1:nb-1); % angle correction vector
    dif_V=dif_Voltage(nb:end); % magnitude correction vector
    V_delta(2:end)=V_delta(2:end)+dif_D; %correct the results, angle and voltage
    V_mag(PQ)=V_mag(PQ)+dif_V;
    tol=max(abs(dif_PQ));
    iter=iter+1;
 end
    if iter>5
        disp('bad, not converge');
    else
        V_result=[V_mag,rad2deg(V_delta)];        
    end  
    %% verify the calculation results
if max(V_result-[V_mag,V_delta])<=0.1
    fprintf('Congratulation,converge!, times of iteration=%d.\n',iter);
else
    disp('converge, but results are not correct, please go back to check!');
end
 end

 



      
      
      
    
      
 

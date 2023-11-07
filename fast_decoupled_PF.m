function[PQ,PV,nPQ,nPV,P_cal,Q_cal,V_result,iter]= fast_decoupled_PF(S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin)
clear all;
%% read grid data from file
cmd='ieee14cdf.txt';
cdf=fopen(cmd); % open data file
[S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin]=Readdata(cdf); 
%%Reading the busdata from file 
V_mag = Busdata(:,5); % magnitude of voltage magnitude in P.U.
V_ang = Busdata(:,6);% voltage angle
P_load= Busdata(:,7)/S;  % Active power of load in P.U.
Q_load= Busdata(:,8)/S;  % Reactive power of load in p.u.
P_gen = Busdata(:,9)/S;   % Active power of the generation in p.u.
Q_gen= Busdata (:,10)/S;  % Reactive power of the generation in P.U.
Q_max= Busdata(:,13)/S;   % Maximum Reactive power limit in P.U
Q_min = Busdata(:,14)/S;   %MInimum Reactive power limit in P.U

 %% type of buses
 slack=find(Busdata(:,4)==3); %slack bus
 PV=find(Busdata(:,4)==2); %PV bus index
 PQ=find(Busdata(:,4)==0|Busdata (:,4) == 1); %PQ bus index
 nslack=length(slack);
 nPQ=length(PQ);
 nPV=length(PV);

  %% form Y_matrix
 [Y_m,Theta,Y_mag,B,G]=Ybus_matrix(Busdata,Linedata,nb,nm);
 
%% from Y_matrix obtain B_mat_dec that used in decouple power flow
[B1,B2]=B_mat(B,nPQ,PQ,nb);

%% initialize parameters
V_mag=Busdata(:,12); %initial voltage
V_mag(~V_mag) = 1; % replace all 0 with 1 for voltage magnitude
V_delta=zeros(nb,1); %initial angle
 P_sch=P_gen-P_load; %net power scheduled at a bus
 Q_sch=Q_gen-Q_load;
 dif_Voltage=zeros(nb-1+nPQ,1);
 
 %% Decoupled power flow calculation start
  tol_max=0.01; % iteration tolerance of the solution
 iter=0; %times of iteration
 tol=1; %initial value of tol
  while (tol>tol_max)
    [P_cal,Q_cal]=cal_PQ(V_mag,Y_mag,Theta,V_delta,nb); %calculate the power at buses       
    % calculate ?P/V
    dif_P_all=P_sch-P_cal;
    dif_P=dif_P_all(2:end);
    for i=2:nb
        dif_P_V(i-1)=dif_P_all(i)/V_mag(i); 
    end
    % calculate voltage angle correction vector using LU factorization
    [dif_D]=LU_factor_PQ(B1,dif_P_V); 
    
    % calculate ?Q/V 
    dif_Q_all=Q_sch-Q_cal;
    dif_Q=zeros(nPQ,1);
    dif_Q_V=zeros(nPQ,1);
    for i=1:nPQ
        dif_Q(i)=dif_Q_all(PQ(i));
        dif_Q_V(i)=dif_Q_all(PQ(i))/V_mag(PQ(i));
    end
    % calculate voltage magnitude correction vector using LU factorization
     [dif_V]=LU_factor_PQ(B2,dif_Q_V); 
     
     %correct the results, voltage magnitude and angle
     V_mag(PQ)=V_mag(PQ)+dif_V;
     V_delta(2:end)=V_delta(2:end)+dif_D;
     dif_PQ=[dif_P;dif_Q];
     tol=max(abs(dif_PQ));
     iter=iter+1;     
 end
     if iter>10  
        disp('bad, not converge');
    else
        V_result=[V_mag,rad2deg(V_delta)];        
     end  
   %% verify the calculation results
if max(V_result-[V_mag,V_delta])<=0.5
    fprintf('Congratulation,converge!,Number of times of iteration=%d.\n',iter);
else
    disp('converge, but results are not correct, please go back to check!');
end
end


    


 
 
  
 
 
 
 
 
    
 
 
 
 
 
         
         
         




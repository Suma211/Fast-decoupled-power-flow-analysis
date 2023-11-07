%% make fast_decouple power flow calculation a function so as to check Q limit after power flow calculation
clear all;
%% read grid data from file
cmd='ieee14cdf.txt';
cdf=fopen(cmd); % open data file
[S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin]=Readdata(cdf);
[PQ,PV,nPQ,nPV,P_cal,Q_cal,V_result]= LU_NRpowerflow(S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin);
 %% check Qlimit for PV buses
Q_cal(2)=80/S; % set Q_cal for bus 2 to 80Mvar, so that the Q_cal is greater than the Q limit
while max(Q_cal(PV)>Qmax(PV))|| max(Q_cal(PV)<Qmin(PV))
    for i=1:nPV
        if Q_cal(PV(i))>Qmax(PV(i))
            Q_cal(PV(i))=Qmax(PV(i));
            Busdata(PV(i),4)=0;
        elseif Q_cal(PV(i))<Qmin(PV(i))
            Q_cal(PV(i))=Qmin(PV(i));
            Busdata(PV(i),4)=0;
        end
    end
[PQ,PV,nPQ,nPV,P_cal,Q_cal,V_result,iter]= fast_decoupled_PF(S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin);
 end
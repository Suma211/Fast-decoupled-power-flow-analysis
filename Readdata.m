function[S,nb,nm,Busdata,Linedata,V_mag,V_ang,P_load,Q_load,P_gen,Q_gen,Qmax,Qmin]=Readdata(cdf)
% clear all;
%Com_data ='ieee14cdf.txt';
% cdf=fopen(Com_data); % open data file
%% Bus data
k_str=fgetl(cdf);  %first line of data
S=str2num(k_str(32:37));
k_str=fgetl(cdf);  %second line of data
Busdata=[];
nb=0;   %no of buses
while ischar(k_str)  %loop till the end 
      k_str=fgetl(cdf);
      if(strcmp(k_str(1:4),'-999') ==1);
          break;
      end
      indx=19; k_str_nm=k_str(indx:end);
      k_nm=str2num(k_str_nm);
      nb=nb+1;
      Busdata=[Busdata; [nb k_nm]];
end         
%% Line Data
k_str=fgetl(cdf);
Linedata=[];
nm=0; % number of lines
while ischar(k_str)
      k_str=fgetl(cdf);
      if(strcmp(k_str(1:4),'-999') ==1)
          break;
      end
      indx=1; k_str_nm=k_str(indx:end);
      k_nm=str2num(k_str_nm);
      nm=nm+1;
      Linedata=[Linedata; [nm k_nm]];
      
 %%Reading the busdata from file 

V_mag = Busdata(:,5); % magnitude of voltage magnitude in P.U.
V_ang = Busdata(:,6);% voltage angle
P_load= Busdata(:,7)/S;  % Active power of load in P.U.
Q_load= Busdata(:,8)/S;  % Reactive power of load in p.u.
P_gen = Busdata(:,9)/S;   % Active power of the generation in p.u.
Q_gen= Busdata (:,10)/S;  % Reactive power of the generation in P.U.
Qmax= Busdata(:,13)/S;   % Maximum Reactive power limit in P.U
Qmin = Busdata(:,14)/S;   %MInimum Reactive power limit in P.U
end

      
      
      
    
      
 
      
      
          
      




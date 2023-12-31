%% Jacobian matrix calculation  
function [J]=Jacobian_Matrix(V_mag,P_cal,Q_cal,Y_mag,Theta, V_delta,nb,PQ,nPQ,B,G)
J1=zeros(nb-1);
J2=zeros(nb-1,nPQ);
J3=zeros(nPQ,nb-1);
J4=zeros(nPQ,nPQ);

%J1=dP/dDelta
for i=2:nb %row position of a bus
    for j=2:nb %column position of bus
        if(j==i) 
                       
            J1(i-1,j-1)=-Q_cal(i)-V_mag(i)^2*B(i,j); %diagonal elements  
        else
            J1(i-1,j-1)= -V_mag(i)*V_mag(j)*Y_mag(i,j)*sin(Theta(i,j)-V_delta(i)+V_delta(j));
        end
    end
end

 %J2=dP/dV
 for i=2:nb %position of row
     for j=1:nPQ  %position of column
         jj=PQ(j);         
         if(jj==i) %diagonal elements     
             J2(i-1,j)=P_cal(i)/V_mag(i)+V_mag(i)*G(i,i);
            
         else %off-diagonal elements
            J2(i-1,j)= V_mag(i)*Y_mag(i,jj)*cos(Theta(i,jj)-V_delta(i)+V_delta(jj));
                 
         end
     end
 end
             
 %J3=dQ/dDelta
 for i=1:nPQ %position of row
     ii=PQ(i);
     for j=2:nb %position of column
         if(j==ii) 
             J3(i,j-1)=P_cal(ii)-G(ii,ii)*(V_mag(ii)^2); %diagonal elements
            
         else  %off-diagonal elements
             J3(i,j-1)=-V_mag(ii)*V_mag(j)*Y_mag(ii,j)*cos(Theta(ii,j)-V_delta(ii)+V_delta(j));
         end
     end
 end
 
 %J4=dQ/dV
 for i=1:nPQ %position of row
     ii=PQ(i);
     for j=1:nPQ %position of colume
         jj=PQ(j);
         if(jj==ii) %diagonal elements 
             J4(i,j)=Q_cal(ii)/V_mag(ii)-V_mag(ii)*B(ii,ii);
             
         else %off-diagonal elements
             J4(i,j)=-V_mag(ii)*Y_mag(ii,jj)*sin(Theta(ii,jj)-V_delta(ii)+V_delta(jj));
                
         end
     
 end
   J=[J1 J2;J3 J4];  
 end
 end
 


        



      
      
      
    
      
 
      
      
          
      




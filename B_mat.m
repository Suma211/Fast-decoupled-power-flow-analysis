function[B1,B2]=B_mat(B,nPQ,PQ,nb)
B1=-B(2:nb,2:nb);
for i=1:nPQ
    for j=1:nPQ
        B2(i,j)=-B(PQ(i),PQ(j));
    end
end
end

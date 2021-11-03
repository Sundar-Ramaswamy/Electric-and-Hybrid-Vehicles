V= v./3.6;
V_z=V(1:1061);

for i=1:1061
    
    x(i)=V(i+1)-V(i);
    
end

D_z= x';
G_z= zeros(length(D_z),1);
T = (1:1061);
T_z = T';

close all; clear; clc;

load Lattice.mat;
C=load('borderdata.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PolyLattice=[];

for k=1:246
    
    disp(k/246*100);
    
    lon=C.lon{k};
    lat=C.lat{k};
    
    lon=cat(2,lon,NaN);
    lat=cat(2,lat,NaN);
    X=cat(2,lon',lat');
    index=inpoly2(Lattice,X);
    index=find(index==1);
    polyLattice=Lattice(index,:);

    PolyLattice=cat(1,PolyLattice,polyLattice);
    
end

save('PolyLattice.mat','PolyLattice','-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,1420,780],'Color','w'); hold on;

scatter(PolyLattice(:,1),PolyLattice(:,2),0.1);
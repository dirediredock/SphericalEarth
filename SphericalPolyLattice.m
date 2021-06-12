
close all; clear; clc; radiusEarth=6371;

load PolyLattice.mat;
A=load('borderdata.mat');

PolyLattice=PolyLattice(1:5:end,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Equator=(-180:1:180)';
Equator=cat(2,Equator,zeros(length(Equator),1));

PrimeMeridian=(-90:1:90)';
PrimeMeridian=cat(2,zeros(length(PrimeMeridian),1),PrimeMeridian);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Lines=[];

for k=1:246
    
   lon=A.lon{k};
   lat=A.lat{k};

   lon=cat(2,lon,NaN);
   lat=cat(2,lat,NaN);
   line=cat(2,lon',lat');
   
   Lines=cat(1,Lines,line);
   
end

figure('Position',[120,60,1420,780],'Color','k');
hold on; axis off; axis tight;

scatter(PolyLattice(:,1),PolyLattice(:,2),0.1);
plot(Lines(:,1),Lines(:,2),'w');

plot(Equator(:,1),Equator(:,2),'c');
plot(PrimeMeridian(:,1),PrimeMeridian(:,2),'c');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(PolyLattice(:,1));
radY=deg2rad(PolyLattice(:,2));
[X,Y,Z]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Lines(:,1));
radY=deg2rad(Lines(:,2));
[iX,iY,iZ]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Equator(:,1));
radY=deg2rad(Equator(:,2));
[iaX,iaY,iaZ]=sph2cart(radX,radY,7000);

radX=deg2rad(PrimeMeridian(:,1));
radY=deg2rad(PrimeMeridian(:,2));
[ibX,ibY,ibZ]=sph2cart(radX,radY,7000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,1420,780],'Color','k'); view(60,-10);
set(gca,'CameraViewAngleMode','manual');
hold on; axis off; axis tight;

scatter3(X,Y,Z,0.1);
plot3(iX,iY,iZ,'w');

plot3(iaX,iaY,iaZ,'c');
plot3(ibX,ibY,ibZ,'c');
plot3(ibX*-1,ibY,ibZ*-1,'c');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

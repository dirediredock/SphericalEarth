
close all; clear; clc; radiusEarth=6371;

C=load('borderdata.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lat=180*rand(500,1)-90; 
lon=360*rand(500,1); 
color=15+10*cosd(lat); 
[X,Y,Z]=sph2cart(deg2rad(lon),deg2rad(lat),radiusEarth);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

step=20;

    Xmin=-180;
    Xmax=+180;
    
        Xi=(Xmin:1/step:Xmax)';
    
    Ymin=-90;
    Ymax=+90;

        Yi=(Ymin:0.5/step:Ymax)';

string=length(Yi);
newOne=ones(string,1);
totalVector=string^2;
latticeX=zeros(totalVector,1);
latticeY=zeros(totalVector,1);

for i=1:string
    b=mod(i,100);
    if b==0
    disp(i);
    end
    latticeX(i*string-string+1:i*string,1)=newOne.*Xi(i,1);
    latticeY(i*string-string+1:i*string,1)=Yi;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,1420,780],'Color','w'); hold on;

Lines=[];

for k=1:246
    
   lon=C.lon{k};
   lat=C.lat{k};

   lon=cat(2,lon,NaN);
   lat=cat(2,lat,NaN);
   line=cat(2,lon',lat');
   
   Lines=cat(1,Lines,line);
end

plot(Lines(:,1),Lines(:,2),'k');
scatter(latticeX,latticeY,0.1);
scatter(lon,lat,50,'r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,1420,780],'Color','k'); colormap(viridis);
set(gca,'CameraViewAngleMode','manual');
hold on; axis off; axis tight;

Borders=[];

for k=1:246
    
   [x,y,z]=sph2cart(deg2rad(C.lon{k}), ...
                    deg2rad(C.lat{k}), ...
                    radiusEarth);
                
   x=cat(2,x,NaN);
   y=cat(2,y,NaN);
   z=cat(2,z,NaN);
   border=cat(2,x',y',z');
   
   Borders=cat(1,Borders,border);
end

plot3(Borders(:,1),Borders(:,2),Borders(:,3),'w');
scatter3(X,Y,Z,50,color);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

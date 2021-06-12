
close all; clear; clc; radiusEarth=6371;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=1:1:3141;

x=sin(y)*180;
x2=cos(y)*180;
y=(y/2)-90;

MeshA=cat(2,x',y');
MeshB=cat(2,x2',y');

figure; hold on;
scatter(MeshA(:,1),MeshA(:,2),'.');
scatter(MeshB(:,1),MeshB(:,2),'.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(MeshA(:,1));
radY=deg2rad(MeshA(:,2));
[Xa,Ya,Za]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(MeshB(:,1));
radY=deg2rad(MeshB(:,2));
[Xb,Yb,Zb]=sph2cart(radX,radY,radiusEarth);

figure('Position',[120,60,1420,780],'Color','k'); view(50,-30);
set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
hold on; axis off; axis tight;

scatter3(Xa,Ya,Za,'.w');
scatter3(Xb,Yb,Zb,'.w');

close all; clear; clc; radiusEarth=6371;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PointClouds

load Lattice.mat;

        index=1:length(Lattice);
        index=randsample(index,999999);
        Lattice=Lattice(index,:);

load PolyLattice.mat;

        PolyLattice=PolyLattice(1:5:end,:);

load meanMLD.mat;

        MLD=squeeze(meanMLD(10,:,:));
        MLD=log10(MLD);
        MLD=MLD';
        MLD(MLD<=1.25)=1.25;
        MLD(MLD>=2.25)=2.25;

        [height,width]=size(MLD);
        [x,y]=meshgrid(1:width,1:height);
        cloud=[x(:),y(:),MLD(:)];

        X=cloud(:,1)-180;
        Y=cloud(:,2)-90;
        N=cloud(:,3);

        MLD=cat(2,X,Y,N);
        MLD(any(isnan(MLD),2),:)=[];
        
% PolyLines

A=load('borderdata.mat');

        Lines=[];

        for k=1:246

            lon=A.lon{k};
            lat=A.lat{k};

            lon=cat(2,lon,NaN);
            lat=cat(2,lat,NaN);
            line=cat(2,lon',lat');

            Lines=cat(1,Lines,line);
        end
        
ArcLine=(-180:1:180)';
ArcLine=cat(2,ArcLine,zeros(length(ArcLine),1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(PolyLattice(:,1));
radY=deg2rad(PolyLattice(:,2));
[X,Y,Z]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Lattice(:,1));
radY=deg2rad(Lattice(:,2));
[Xdark,Ydark,Zdark]=sph2cart(radX,radY,6300);

radX=deg2rad(Lines(:,1));
radY=deg2rad(Lines(:,2));
[iX,iY,iZ]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(ArcLine(:,1));
radY=deg2rad(ArcLine(:,2));
[arcX,arcY,arcZ]=sph2cart(radX,radY,8000);

    figure('Position',[120,60,1420,780],'Color','k'); view(50,-30);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    scatter3(Xdark,Ydark,Zdark,0.2,'k');
   %plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
   %plot3(arcZ,arcX,arcY,'c');

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(MLD(:,1));
radY=deg2rad(MLD(:,2));
[MLDx,MLDy,MLDz]=sph2cart(radX,radY,radiusEarth);

    figure('Position',[120,60,1420,780],'Color','k'); view(50,-30);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    scatter3(Xdark,Ydark,Zdark,0.2,'k');
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
   %plot3(arcZ,arcX,arcY,'c');

    BiofilmMLD=cat(2,MLDx,MLDy,MLDz);

    scatter3(BiofilmMLD(:,1),BiofilmMLD(:,2),BiofilmMLD(:,3), ...
        8,MLD(:,3),'filled');

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
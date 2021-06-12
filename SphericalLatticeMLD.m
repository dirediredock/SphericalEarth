
close all; clear; clc; radiusEarth=6371;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Equator=(-180:1:180)';
Equator=cat(2,Equator,zeros(length(Equator),1));

PrimeMeridian=(-90:1:90)';
PrimeMeridian=cat(2,zeros(length(PrimeMeridian),1),PrimeMeridian);

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

    figure('Position',[120,60,1420,780],'Color','k');
    hold on; axis off; axis tight; colormap(viridis); caxis([1.25,2.25]);

    scatter(PolyLattice(:,1),PolyLattice(:,2),0.1);
    plot(Lines(:,1),Lines(:,2),'w');
    scatter(MLD(:,1),MLD(:,2),10,MLD(:,3),'filled');
    plot(Equator(:,1),Equator(:,2),'c');
    plot(PrimeMeridian(:,1),PrimeMeridian(:,2),'c');

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(PolyLattice(:,1));
radY=deg2rad(PolyLattice(:,2));
[X,Y,Z]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Lines(:,1));
radY=deg2rad(Lines(:,2));
[iX,iY,iZ]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Equator(:,1));
radY=deg2rad(Equator(:,2));
[arcX,arcY,arcZ]=sph2cart(radX,radY,8000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(MLD(:,1));
radY=deg2rad(MLD(:,2));
radZ=rescale(MLD(:,3).^10,radiusEarth,8000);

PointsMLD=[];

for i=1:length(radX)
    
    [MLDx,MLDy,MLDz]=sph2cart(radX(i,:),radY(i,:),radZ(i,:));
    triplet=cat(2,MLDx,MLDy,MLDz);
    PointsMLD=cat(1,PointsMLD,triplet);
end

    figure('Position',[120,60,1420,780],'Color','k'); view(50,-30);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

    scatter3(PointsMLD(:,1),PointsMLD(:,2),PointsMLD(:,3), ...
        8,MLD(:,3),'filled');

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(MLD(:,1));
radY=deg2rad(MLD(:,2));
[MLDx,MLDy,MLDz]=sph2cart(radX,radY,radiusEarth);

    figure('Position',[120,60,1420,780],'Color','k'); view(50,-30);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

    BiofilmMLD=cat(2,MLDx,MLDy,MLDz);

    scatter3(BiofilmMLD(:,1),BiofilmMLD(:,2),BiofilmMLD(:,3), ...
        8,MLD(:,3),'filled');

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorspace=viridis(25);
index=rescale(radZ(:,1),1,length(colorspace));
index=round(index);

    figure('Position',[120,60,1420,780],'Color','k'); view(120,-50);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

for i=1:length(radZ)
    
    pointA=cat(2,BiofilmMLD(i,1),BiofilmMLD(i,2),BiofilmMLD(i,3));
    pointB=cat(2,PointsMLD(i,1),PointsMLD(i,2),PointsMLD(i,3));
    line=cat(1,pointA,pointB);
    plot3(line(:,1),line(:,2),line(:,3),'Color',colorspace(index(i,:),:));
    
    b=mod(i,3000);
    if b==0
        drawnow;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorspace=viridis(length(PointsMLD(:,3)));
index=rescale(radZ(:,1),1,length(radZ));
index=round(index);

    figure('Position',[120,60,1420,780],'Color','k'); view(120,-50);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
    plot3(arcZ,arcX,arcY,'c');

for i=1:length(radZ)
    
    pointA=cat(2,BiofilmMLD(i,1),BiofilmMLD(i,2),BiofilmMLD(i,3));
    pointB=cat(2,PointsMLD(i,1),PointsMLD(i,2),PointsMLD(i,3));
    line=cat(1,pointA,pointB);
    plot3(line(:,1),line(:,2),line(:,3),'Color',colorspace(index(i,:),:));
    
    b=mod(i,3000);
    if b==0
        drawnow;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorspace=viridis(length(PointsMLD(:,3)));
index=rescale(radZ(:,1),1,length(radZ));
index=round(index);

    figure('Position',[120,60,1420,780],'Color','k'); view(120,-50);
    set(gca,'CameraViewAngleMode','manual'); colormap(viridis);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

for i=1:length(radZ)
    
    pointA=cat(2,BiofilmMLD(i,1),BiofilmMLD(i,2),BiofilmMLD(i,3));
    pointB=cat(2,PointsMLD(i,1),PointsMLD(i,2),PointsMLD(i,3));
    line=cat(1,pointA,pointB);
    plot3(line(:,1),line(:,2),line(:,3),'w');
    
    b=mod(i,3000);
    if b==0
        drawnow;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
